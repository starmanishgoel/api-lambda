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
    print "Recieved ( %d ) for Factorial Function" % (number)
    try:
        output = factorial(number)
        print "%d total recursions" % (recursions) 
    except Exception, e:
        print "Exception occurred after %d recursions" % (recursions)
        output = "Factorial Function failed at %d recursions" % (recursions)
    return {"message": output }

recursions = 0  
def factorial(number):
    global recursions
    if number == 1 or number == 0:
        return 1
    handle_odd = False
    upto_number = number

    if number & 1 == 1:
        upto_number -= 1
        print upto_number
        handle_odd = True

    next_sum = upto_number
    next_multi = upto_number
    factorial = 1

    while next_sum >= 2:
        factorial *= next_multi
        next_sum -= 2
        next_multi += next_sum

    if handle_odd:
        factorial *= number

    return factorial
