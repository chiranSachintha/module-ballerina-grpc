import ballerina/grpc;
import ballerina/protobuf.types.wrappers;

const string HELLOWORLDBYTES_DESC = "0A1568656C6C6F576F726C6442797465732E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F324F0A0A68656C6C6F576F726C6412410A0568656C6C6F121B2E676F6F676C652E70726F746F6275662E427974657356616C75651A1B2E676F6F676C652E70726F746F6275662E427974657356616C7565620670726F746F33";

public isolated client class helloWorldClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, HELLOWORLDBYTES_DESC);
    }

    isolated remote function hello(byte[]|wrappers:ContextBytes req) returns byte[]|grpc:Error {
        map<string|string[]> headers = {};
        byte[] message;
        if req is wrappers:ContextBytes {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <byte[]>result;
    }

    isolated remote function helloContext(byte[]|wrappers:ContextBytes req) returns wrappers:ContextBytes|grpc:Error {
        map<string|string[]> headers = {};
        byte[] message;
        if req is wrappers:ContextBytes {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("helloWorld/hello", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <byte[]>result, headers: respHeaders};
    }
}

public client class HelloWorldByteCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBytes(byte[] response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBytes(wrappers:ContextBytes response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

