print("Hello, Swift !")

let numbers: [Int] = [1, 2, 3, 4, 5]
let sum: Int = numbers.reduce(0, +)

print("Sum of numbers, \(sum)")

func greet(name: String) -> String {
    return "Hello, \(name)"
}

print(greet(name: "Guillaume"))
