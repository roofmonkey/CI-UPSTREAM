import sys

'''
  example: python version_incrementer.py 1.2.3
  input: A version string (i.e. "1.2.3")
  output: Writes incremented version to std out ( "1.2.4") 
'''

v1 = str(sys.argv[1])

v1List = v1.split('.')

v2 = str(v1List[0])+"."+str(v1List[1])+"."+ str(int(v1List[2])+1)
print v2;
