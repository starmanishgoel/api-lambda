import json 
def handler(event, context):
    try:
        x = int(event['m'])
        y = int(event['n'])
        if x<0 or y<0:
            print "Non postive values recieved"
            return {"message": "Positive Integer Required" }
    except Exception, e:
        print "String values recieved"
        return {"message": "Positive Integer Required" }
    print "Recieved ( %d , %d) for Ackermann Function" % (x, y)
    try:
        output = ackermann(x, y)
        print "%d total recursions, %d operations avoided" % (recursions, jumps) 
    except Exception, e:
        print "Exception occurred after %d recursions" % (recursions)
        output = "Ackermann Function failed at %d recursions" % (recursions)
    return {"message": output }
    

res = {}  
jumps = 0  
recursions = 0  
  
def ackermann(x, y):  
  global res, jumps, recursions  
  
  recursions += 1  
  try:  
    jumps += 1  
    return res[x][y]  
  except Exception, e:  
    jumps -= 1  
    res[x] = {}  
  
  if x == 0:  
    res[x][y] = y+1 
  if x ==1 :
    res[x][y] = y+2  
  else:  
    if y == 0:  
      res[x][y] = ackermann(x-1, 1)  
    else:  
      res[x][y] = ackermann(x-1, ackermann(x, y-1))  
  
  return res[x][y]  




