let words: [String] = [
    "Swift", "is", "a", "powerful", "language", "Swift", "is", "also", "easy", "to", "learn",
    "Python", "is", "also", "powerful",
]

func countWordFrequency(_ words: [String]) -> [String: Int] {
    var dict: [String: Int] = [:]
    for word: String in words.map({ $0.lowercased() }) {  // Make it case-insensitive
        dict[word, default: 0] += 1  // Use default value if key doesn't exist
    }
    return dict
}

func printRepeatedWords(_ frequencyDict: [String: Int]) {
    let sortedWords: [Dictionary<String, Int>.Element] = frequencyDict.filter { $0.value > 1 }  // Filter before sorting
        .sorted { $0.value > $1.value }
    for (word, count) in sortedWords {
        print("\(word): \(count)")
    }
}

// Call the functions
let frequencyDict: [String: Int] = countWordFrequency(words)
printRepeatedWords(frequencyDict)
