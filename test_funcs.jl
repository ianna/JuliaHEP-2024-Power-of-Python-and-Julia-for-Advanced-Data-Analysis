using AwkwardArray

function f1(x)
  print(typeof(x))
  return AwkwardArray.convert(x)
end;