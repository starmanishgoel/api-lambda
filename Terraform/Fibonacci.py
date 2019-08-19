import json 

def handler(event, context):
    try:
        number = int(event['num'])
        
        if number<0 :
            print "Non postive values recieved"
            return {"message": "Positive Integer Required" }
    except Exception, e:
        print "String values recieved"
        return {"message": "Positive Integer Required" }
    print "Recieved ( %d ) for Fibonacci Function" % (number)
    try:
        output = fibonacci(number)
        print "%d total recursions" % (recursions) 
    except Exception, e:
        print "Exception occurred after %d recursions" % (recursions)
        output = "Fibonacci Function failed at %d recursions" % (recursions)
    return {"message": output }
    #return { "statusCode": 200,"headers": {"message": output },"body": JSON.stringify(responseBody),"isBase64Encoded": false}

recursions = 0  
def fibonacci(n): 
    global recursions
    a = 0
    b = 1
    if n < 0: 
        print("Only positive numbers allowed") 
    elif n == 0: 
        return a 
    elif n == 1: 
        return b 
    else: 
        for i in range(2,n): 
            recursions += 1
            c = a + b 
            a = b 
            b = c 
        return b 