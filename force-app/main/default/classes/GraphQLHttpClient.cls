global class GraphQLHttpClient implements IGraphQLClient {
    private final String endpoint;

    private static final Integer REQUEST_TIMEOUT = GraphQLConfigurationManager.getConfigurationAsInt(
        GraphQLConfiguration.RequestTimeout
    );

    private static final Boolean SEND_PRETTY_REQUEST = GraphQLConfigurationManager.getConfigurationAsBool(
        GraphQLConfiguration.SendPrettyQuery
    );

    global GraphQLHttpClient() {
        this.endpoint = GraphQLConfigurationManager.getConfiguration(
            GraphQLConfiguration.DefaultGraphQLEndpoint
        );
        if (String.isBlank(this.endpoint) || this.endpoint == 'null') {
            throw new GraphQLHttpClientException(Label.NoEndpointProvidedError);
        }
    }

    global GraphQLHttpClient(String endpoint) {
        this.endpoint = endpoint;
    }
    
    global GraphQLResponse send(GraphQLRequest request) {
        return send(new RequestWrapper(request));
    }

    global Id sendAsync(GraphQLRequest request, IGraphQLResponseCallback callback) {
        return System.enqueueJob(
            new QueuableRequestWrapper(this, new RequestWrapper(request), callback)
        );
    }

    private GraphQLResponse send(RequestWrapper request) {
        HttpResponse httpResponse = new Http().send(prepareRequest(request));
        GraphQLResponse gqlResponse;
        try {
            gqlResponse = GraphQLResponse.parse(httpResponse.getBody());
        } catch (JSONException error) {
            gqlResponse = new GraphQLResponse(
                putError(
                    error,
                    Label.UnexpectedResponseFormatError +
                    CommonConstants.LINE_BREAK +
                    httpResponse.getBody()
                )
            );
        } catch (Exception error) {
            gqlResponse = new GraphQLResponse(putError(error, Label.UnexpectedClientError));
        }

        return gqlResponse;
    }

    private HttpRequest prepareRequest(RequestWrapper gqlRequest) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(HttpConstants.METHOD_POST);

        request.setTimeout(REQUEST_TIMEOUT);

        request.setHeader(
            HttpConstants.HEADER_NAME_CONTENT_TYPE,
            HttpConstants.HEADER_VALUE_MIMETYPE_JSON
        );
        request.setHeader(
            HttpConstants.HEADER_NAME_ACCEPT,
            HttpConstants.HEADER_VALUE_MIMETYPE_JSON
        );

        for (String header : gqlRequest.headers.keySet()) {
            request.setHeader(header, gqlRequest.headers.get(header));
        }

        request.setBody(gqlRequest.body);
        return request;
    }

    private GraphQLResponseError putError(Exception error, String message) {
        System.debug(
            LoggingLevel.ERROR,
            error.getMessage() +
            CommonConstants.LINE_BREAK +
            error.getStackTraceString()
        );
        return new GraphQLResponseError(message);
    }

    // This wrapper is needed because of the "Processing" issue with the Queueable job
    private class RequestWrapper {
        public Map<String, String> headers;
        public String body;

        public RequestWrapper(GraphQLRequest request) {
            this.headers = request.customHeaders;
            this.body = request.toString(SEND_PRETTY_REQUEST);
        }
    }

    private class QueuableRequestWrapper implements Queueable, Database.AllowsCallouts {
        private final GraphQLHttpClient client;
        private final RequestWrapper request;
        private final IGraphQLResponseCallback callback;

        public QueuableRequestWrapper(
            GraphQLHttpClient client,
            RequestWrapper request,
            IGraphQLResponseCallback callback
        ) {
            this.client = client;
            this.request = request;
            this.callback = callback;
        }

        public void execute(QueueableContext context) {
            GraphQLResponse response = client.send(request);
            if (callback != null) {
                callback.received(response);
            }
        }
    }

    private class GraphQLHttpClientException extends Exception {
    }
}