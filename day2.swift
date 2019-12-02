#! /usr/bin/swift

func run(_ code: inout [Int], _ noun: Int, _ verb: Int) -> Int {
  var ip = 0
  code[1] = noun
  code[2] = verb

  while code[ip] != 99 {
    if code[ip] == 1 {
      code[code[ip + 3]] = code[code[ip + 1]] + code[code[ip + 2]]
    } else {
      code[code[ip + 3]] = code[code[ip + 1]] * code[code[ip + 2]]
    }
    ip += 4
  }
  return code[0]
}

var code = readLine()!.split(separator: ",").map { Int($0)! }

var memory = code
print(run(&memory, 12, 2))

outer: for noun in stride(from: 0, through: 100, by: 1) {
  for verb in stride(from: 0, through: 100, by: 1) {
    memory = code
    if run(&memory, noun, verb) == 19690720 {
      print("\(noun * 100 + verb)")
      break outer
    }
  }
}
