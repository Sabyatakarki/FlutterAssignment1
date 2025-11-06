// banking_system.dart
//OOP in Dart: Encapsulation, Inheritance, Polymorphism, Abstraction

// Abstract class BankAccount
abstract class BankAccount {
  String _accountNumber;
  String _accountHolderName;
  double _balance;

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // Getters and setters for encapsulation
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  set balance(double value) {
    if (value >= 0) {
      _balance = value;
    } else {
      print("Invalid balance value!");
    }
  }

  // Abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  // Method to display account information
  void displayAccountInfo() {
    print("Account Number: $_accountNumber");
    print("Account Holder: $_accountHolderName");
    print("Balance: \$$_balance\n");
  }
}

// Interface/abstract class for interest bearing accounts
abstract class InterestBearing {
  void calculateInterest();
}

// Savings Account
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500.0;
  static const double interestRate = 0.02;
  int withdrawalCount = 0;

  SavingsAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount} into Savings Account");
  }

  @override
  void withdraw(double amount) {
    if (withdrawalCount >= 3) {
      print("Withdrawal limit reached!");
      return;
    }
    if (balance - amount >= minBalance) {
      balance -= amount;
      withdrawalCount++;
      print("Withdrew \$${amount} from Savings Account");
    } else {
      print("Cannot withdraw! Minimum balance requirement not met.");
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    balance += interest;
    print("Interest of \$${interest} added to Savings Account");
  }
}

// Checking Account
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35.0;

  CheckingAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount} into Checking Account");
  }

  @override
  void withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= overdraftFee;
      print("Overdraft! Fee of \$${overdraftFee} applied.");
    }
    print("Withdrew \$${amount} from Checking Account");
  }
}

// Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000.0;
  static const double interestRate = 0.05;

  PremiumAccount(String accNo, String name, double balance)
      : super(accNo, name, balance);

  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited \$${amount} into Premium Account");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount >= minBalance) {
      balance -= amount;
      print("Withdrew \$${amount} from Premium Account");
    } else {
      print("Minimum balance requirement not met!");
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * interestRate;
    balance += interest;
    print("Interest of \$${interest} added to Premium Account");
  }
}

// Bank class
class Bank {
  List<BankAccount> accounts = [];

  void createAccount(BankAccount account) {
    accounts.add(account);
    print("Account created for ${account.accountHolderName}");
  }

  BankAccount? findAccount(String accNo) {
    for (var account in accounts) {
      if (account.accountNumber == accNo) {
        return account;
      }
    }
    print("Account not found!");
    return null;
  }

  void transfer(String fromAcc, String toAcc, double amount) {
    var sender = findAccount(fromAcc);
    var receiver = findAccount(toAcc);
    if (sender != null && receiver != null) {
      sender.withdraw(amount);
      receiver.deposit(amount);
      print("Transferred \$${amount} from ${sender.accountHolderName} to ${receiver.accountHolderName}");
    }
  }

  void generateReport() {
    print("\n---- Bank Account Report ----");
    for (var account in accounts) {
      account.displayAccountInfo();
    }
  }
}

// Main Function
void main() {
  var bank = Bank();

  var savings = SavingsAccount("S001", "Sabbu", 1000);
  var checking = CheckingAccount("C001", "Aditi", 200);
  var premium = PremiumAccount("P001", "sabyata", 15000);

  bank.createAccount(savings);
  bank.createAccount(checking);
  bank.createAccount(premium);

  savings.deposit(200);
  savings.withdraw(100);
  savings.calculateInterest();

  checking.withdraw(300);
  premium.calculateInterest();

  bank.transfer("S001", "C001", 100);
  bank.generateReport();
}
