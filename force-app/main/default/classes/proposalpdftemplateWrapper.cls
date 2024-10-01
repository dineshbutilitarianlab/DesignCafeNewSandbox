public class proposalpdftemplateWrapper {
    
    public string type;
    public string mime;
    public string file;
    public body body;
    public class body{
        public string to;
        public string ttl;
        public string type;
        public template template;
    }
    public class template{
        public string namespace;
        public string name;
        public language language;
        public list<components> components;
    }
    public class language{
        public string policy;
        public string code;
    }
    
    public class components{
        public string type;
        public list<parameters> parameters;
    }
    public class parameters{
        public string type;
        public string text;   
        public document document;
    }
    public class document{
        public string filename;
    }
}