class Node :
  def __init__ (self) :
    self.n = 0
    self.e = ''

class Queue :
  def __init__ (self) :
    self.head = None
    self.tail = None
  
  def isNotEmpty(self):
    return self.head==None
  
  def add(self, data):
    new_data = Node()
    new_data.e=data
    if self.head is None:
      self.head = new_data
      self.tail = self.head
    else:
      self.tail.n = new_data
      self.tail = new_data
  
  def remove(self):
    data = self.head.e
    self.head = self.head.n
    if self.head is None:
      self.tail is None
    return data

  def getSmaller(self):
    menor=self.head.e
    m2=self.head.n.e
    while(self.head!=self.tail.n):
      if menor > self.head.e :
        menor=self.head.e
      self.head=self.head.n
    return menor


q = Queue ()
q.add("f")
q.add("a")
q.add("w")
q.getSmaller()