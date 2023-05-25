import ballerina/lang.regexp;
import ballerina/time;
import ballerina/io;

function measure(string data, string pattern) {

    time:Utc startTime = time:utcNow();

    string:RegExp re = re `${pattern}`;

    regexp:Span[] matches = re.findAll(data);

    time:Utc endTime = time:utcNow();
    time:Seconds elapsedTime = time:utcDiffSeconds(endTime, startTime);

    io:println(elapsedTime * 1000, "-", matches.length());
}

public function main(string? filePath) returns error? {
    
    if filePath == () {
        io:println("Usage: bal run <filename>");
        return;
    }

    final string data = check io:fileReadString(filePath);

    // Email
    measure(data, "[\\w.+-]+@[\\w.-]+\\.[\\w.-]+");
    
    // Uri
    measure(data, "[\\w]+://[^/\\s?#]+[^\\s?#]+(?:\\?[^\\s#]*)?(?:#[^\\s]*)?");
    
    // IP
    measure(data, "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9])");
}
