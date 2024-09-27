import Foundation

// MARK: - Protocols and Enums

protocol LibraryItem {
    var title: String { get }
    var itemID: String { get }
    var isAvailable: Bool { get set }
    var borrowedDate: Date? { get set }

    func displayInfo() -> String
    mutating func checkOut()
    mutating func checkIn()
}

enum Genre: String, CaseIterable {
    case novel, poetry, theater, comics
}

enum LibraryError: Error {
    case bookUnavailable
    case bookNotBorrowed
    case patronNotFound
    case bookNotFound
}

// MARK: - Structs

struct Book: LibraryItem, Equatable {
    let title: String
    let author: String
    let genre: Genre
    let itemID: String
    var isAvailable: Bool = true
    var borrowedDate: Date?

    func displayInfo() -> String {
        return "\(title) by \(author) - \(genre.rawValue)"
    }

    mutating func checkOut() {
        isAvailable = false
        borrowedDate = Date()
    }

    mutating func checkIn() {
        isAvailable = true
        borrowedDate = nil
    }
}

struct Patron: Equatable {
    let patronID: Int
    var name: String
    var borrowedBooks: [Book]

    func displayInfo() -> String {
        return "Patron #\(patronID) - \(name)"
    }
}

// MARK: - Library Class

class Library {
    private var books: [Book] = []
    private var patrons: [Patron] = []

    func addBook(_ book: Book) {
        books.append(book)
    }
    
    func addPatron(_ patron: Patron) {
        patrons.append(patron)
    }

    func borrowBook(patronID: Int, bookID: String) throws {
        guard var patron = patrons.first(where: { $0.patronID == patronID }) else {
            throw LibraryError.patronNotFound
        }
        guard var book = books.first(where: { $0.itemID == bookID }) else {
            throw LibraryError.bookNotFound
        }
        guard book.isAvailable else {
            throw LibraryError.bookUnavailable
        }

        book.checkOut()
        patron.borrowedBooks.append(book)
        
        // Update the book and patron in the arrays
        if let bookIndex = books.firstIndex(where: { $0.itemID == bookID }) {
            books[bookIndex] = book
        }
        if let patronIndex = patrons.firstIndex(where: { $0.patronID == patronID }) {
            patrons[patronIndex] = patron
        }
    }

    func returnBook(patronID: Int, bookID: String) throws {
        guard var patron = patrons.first(where: { $0.patronID == patronID }) else {
            throw LibraryError.patronNotFound
        }
        guard var book = books.first(where: { $0.itemID == bookID }) else {
            throw LibraryError.bookNotFound
        }
        guard !book.isAvailable else {
            throw LibraryError.bookNotBorrowed
        }

        book.checkIn()
        patron.borrowedBooks.removeAll { $0.itemID == bookID }
        
        // Update the book and patron in the arrays
        if let bookIndex = books.firstIndex(where: { $0.itemID == bookID }) {
            books[bookIndex] = book
        }
        if let patronIndex = patrons.firstIndex(where: { $0.patronID == patronID }) {
            patrons[patronIndex] = patron
        }
    }

    func findBooksByGenre(_ genre: Genre) -> [Book] {
        books.filter { $0.genre == genre }
    }

    func findOverdueBooks() -> [Book] {
        let fourteenDaysAgo = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        return books.filter { book in
            guard let borrowedDate = book.borrowedDate else { return false }
            return !book.isAvailable && borrowedDate < fourteenDaysAgo
        }
    }
}

// MARK: - Library Extensions

extension Library {
    func displayBooks() -> String {
        books.map { $0.displayInfo() }.joined(separator: "\n")
    }

    func displayPatrons() -> String {
        patrons.map { $0.displayInfo() }.joined(separator: "\n")
    }

    func displayBooksByGenre(_ genre: Genre) -> String {
        findBooksByGenre(genre).map { $0.displayInfo() }.joined(separator: "\n")
    }

    func displayOverdueBooks() -> String {
        findOverdueBooks().map { $0.displayInfo() }.joined(separator: "\n")
    }
}

// MARK: - Usage Example

let library = Library()

// Add books
library.addBook(Book(title: "1984", author: "George Orwell", genre: .novel, itemID: "B001"))
library.addBook(Book(title: "The Raven", author: "Edgar Allan Poe", genre: .poetry, itemID: "B002"))

// Add patrons
library.addPatron(Patron(patronID: 1, name: "John Doe", borrowedBooks: []))

// Borrow a book
do {
    try library.borrowBook(patronID: 1, bookID: "B001")
    print("Book borrowed successfully\n")
} catch {
    print("Error: \(error)")
}

// Display all books
print("All Books:\n\n\(library.displayBooks())\n")

// Display overdue books
print("Overdue Books:\n\n\(library.displayOverdueBooks())\n")

// Display books by genre
print("Poetry Books:\n\n\(library.displayBooksByGenre(.poetry))\n")