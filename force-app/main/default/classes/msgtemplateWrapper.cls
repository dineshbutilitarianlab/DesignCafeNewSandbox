public class msgtemplateWrapper {
    public body body;
    public class body{
        public string to;
        public decimal ttl;
        public string type;
        public template template;
    }
    public class template{
        public string namespace;
        public string name;
        public language language;
    }
    public class language{
        public string policy;
        public string code;
    }
}