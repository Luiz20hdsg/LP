class Node :
  def __init__ (self) :
    self.n = 0
    self.e = ''

class Stack :
  def __init__ (self) :
    self.top = None

  def add(self, data):
   # if not self.top:
    #  self.top = Node()
   #   self.top.e=data
    #  self.top.n=None
     # print(self.top.e)
   # else:
    #  self.top = Node()
    #  self.top.e=data
   #   self.top.n=self.top
      #print(self.top.e)

    new_data = Node()
    new_data.e=data
    if self.top is None:
      self.top=new_data
    else:
      new_data.n=self.top
      self.top=new_data
     

  def remove(self):
    if self.top:
      data = self.top.e
      self.top = self.top.n
      return data
   
    print('remove from empty stack')

  def pop(self):
    if self.top:
      data=self.top.e
      self.top=self.top.n
      return data
    else:
      return None
   

  def isNotEmpty(self):
    return self.top==None
    



s = Stack()

s.add("Baltimore ")
s.add("Lord ")
s.add("Sir")


print(s.remove())
print(s.remove())
print(s.remove())






