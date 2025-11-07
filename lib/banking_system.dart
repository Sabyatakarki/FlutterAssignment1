//Task - Bnanking System with Multiple Account Types


abstract class InterestBearing {
  void addInterest();
}

abstract class BankAccount {
  // Private fields
  final String _accountNumber;
  final String _accountHolderName;
  double _balance;
  List<String> transactionHistory = [];

  // Constructor
  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // Getters
  String get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  // Setter
  set balance(double value) {
    if (value >= 0) _balance = value;
  }

  // Abstract methods
  void deposit(double amount);
  void withdraw(double amount);

  // Display account info
  void displayAccountInfo() {
    print(
        "Account: $_accountNumber | Holder: $_accountHolderName | Balance: \$${_balance.toStringAsFixed(2)}");
  }

  // Show transaction history
  void showTransactionHistory() {
    print("\nTransaction History for $_accountHolderName:");
    for (var t in transactionHistory) {
      print("- $t");
    }
  }
}

// -------------------- SAVINGS ACCOUNT --------------------
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500;
  static const double interestRate = 0.02;
  int withdrawalCount = 0;
  static const int maxWithdrawalsPerMonth = 3;

  SavingsAccount(String accountNumber, String accountHolderName, double balance)
      : super(accountNumber, accountHolderName, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      transactionHistory.add("Deposited \$${amount.toStringAsFixed(2)}");
      print("Deposited \$${amount.toStringAsFixed(2)} into $accountHolderName's Savings Account");
    } else {
      print("Invalid deposit amount!");
    }
  }

  @override
  void withdraw(double amount) {
    if (withdrawalCount >= maxWithdrawalsPerMonth) {
      print("Withdrawal limit reached for this month!");
      return;
    }
    if (amount > 0 && _balance - amount >= minBalance) {
      _balance -= amount;
      withdrawalCount++;
      transactionHistory.add("Withdrew \$${amount.toStringAsFixed(2)}");
      print("Withdrew \$${amount.toStringAsFixed(2)} from $accountHolderName's Savings Account");
    } else {
      print("Cannot withdraw. Minimum balance requirement: \$${minBalance}");
    }
  }

  @override
  void addInterest() {
    double interest = _balance * interestRate;
    _balance += interest;
    transactionHistory.add("Interest added: \$${interest.toStringAsFixed(2)}");
    print("Interest of \$${interest.toStringAsFixed(2)} added to $accountHolderName's Savings Account");

    resetWithdrawalCount();
  }

  void resetWithdrawalCount() {
    withdrawalCount = 0;
  }
}

// -------------------- CHECKING ACCOUNT --------------------
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35;

  CheckingAccount(String accountNumber, String accountHolderName, double balance)
      : super(accountNumber, accountHolderName, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      transactionHistory.add("Deposited \$${amount.toStringAsFixed(2)}");
      print("Deposited \$${amount.toStringAsFixed(2)} into $accountHolderName's Checking Account");
    } else {
      print("Invalid deposit amount!");
    }
  }

  @override
  void withdraw(double amount) {
    if (amount > 0) {
      _balance -= amount;
      transactionHistory.add("Withdrew \$${amount.toStringAsFixed(2)}");
      if (_balance < 0) {
        _balance -= overdraftFee;
        transactionHistory.add("Overdraft fee applied: \$${overdraftFee.toStringAsFixed(2)}");
        print("Overdraft! Fee of \$${overdraftFee.toStringAsFixed(2)} applied.");
      }
      print("Withdrew \$${amount.toStringAsFixed(2)} from $accountHolderName's Checking Account");
    } else {
      print("Invalid withdrawal amount!");
    }
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double interestRate = 0.05;

  PremiumAccount(String accountNumber, String accountHolderName, double balance)
      : super(accountNumber, accountHolderName, balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      transactionHistory.add("Deposited \$${amount.toStringAsFixed(2)}");
      print("Deposited \$${amount.toStringAsFixed(2)} into $accountHolderName's Premium Account");
    } else {
      print("Invalid deposit amount!");
    }
  }

  @override
  void withdraw(double amount) {
    if (_balance - amount >= minBalance) {
      _balance -= amount;
      transactionHistory.add("Withdrew \$${amount.toStringAsFixed(2)}");
      print("Withdrew \$${amount.toStringAsFixed(2)} from $accountHolderName's Premium Account");
    } else {
      print("Cannot withdraw. Minimum balance required: \$${minBalance}");
    }
  }

  @override
  void addInterest() {
    double interest = _balance * interestRate;
    _balance += interest;
    transactionHistory.add("Interest added: \$${interest.toStringAsFixed(2)}");
    print("Interest of \$${interest.toStringAsFixed(2)} added to $accountHolderName's Premium Account");
  }
}

//Added Student Account
class StudentAccount extends BankAccount {
  static const double maxBalance = 5000;

  StudentAccount(String accountNumber, String accountHolderName, double balance)
      : super(accountNumber, accountHolderName, balance);

  @override
  void deposit(double amount) {
    if (_balance + amount <= maxBalance) {
      _balance += amount;
      transactionHistory.add("Deposited \$${amount.toStringAsFixed(2)}");
      print("Deposited \$${amount.toStringAsFixed(2)} into $accountHolderName's Student Account");
    } else {
      print("Cannot exceed maximum balance of \$${maxBalance}");
    }
  }

  @override
  void withdraw(double amount) {
    if (amount <= _balance) {
      _balance -= amount;
      transactionHistory.add("Withdrew \$${amount.toStringAsFixed(2)}");
      print("Withdrew \$${amount.toStringAsFixed(2)} from $accountHolderName's Student Account");
    } else {
      print("Insufficient balance!");
    }
  }
}

class Bank {
  List<BankAccount> accounts = [];

  void addAccount(BankAccount account) {
    accounts.add(account);
    print("Account created for ${account.accountHolderName}");
  }

  BankAccount? findAccount(String accountNumber) {
    try {
      return accounts.firstWhere((a) => a.accountNumber == accountNumber);
    } catch (e) {
      print("Account $accountNumber not found!");
      return null;
    }
  }

  void transfer(String fromAccountNumber, String toAccountNumber, double amount) {
    var from = findAccount(fromAccountNumber);
    var to = findAccount(toAccountNumber);

    if (from != null && to != null) {
      if (amount > 0 && from.balance >= amount) {
        from.withdraw(amount);
        to.deposit(amount);
        from.transactionHistory.add("Transferred \$${amount.toStringAsFixed(2)} to ${to.accountHolderName}");
        to.transactionHistory.add("Received \$${amount.toStringAsFixed(2)} from ${from.accountHolderName}");
        print("Transferred \$${amount.toStringAsFixed(2)} from ${from.accountHolderName} to ${to.accountHolderName}");
      } else {
        print("Insufficient balance for transfer!");
      }
    }
  }

// ...existing code...
  void applyMonthlyInterest() {
    for (var account in accounts) {
      if (account is InterestBearing) {
        (account as InterestBearing).addInterest(); // explicit cast fixes the error
      }
    }
  }
// ...existing code...

  void showReport() {
    print("\n---- Bank Account Report ----");
    for (var account in accounts) {
      account.displayAccountInfo();
    }
  }
}

// -------------------- MAIN --------------------
void main() {
  var bank = Bank();

  var acc1 = SavingsAccount("S001", "Sabbu", 1000);
  var acc2 = CheckingAccount("C001", "Aditi", 200);
  var acc3 = PremiumAccount("P001", "Sabyata", 15000);
  var acc4 = StudentAccount("ST001", "Ashree", 1000);

  bank.addAccount(acc1);
  bank.addAccount(acc2);
  bank.addAccount(acc3);
  bank.addAccount(acc4);

  // Transactions
  acc1.deposit(200);
  acc1.withdraw(100);
  acc3.addInterest();
  acc4.deposit(4200);
  acc4.withdraw(500);
  acc4.deposit(1000); // Should show error

  bank.transfer("S001", "C001", 100);
  bank.applyMonthlyInterest();

  bank.showReport();

  print("\n---- Transaction Histories ----");
  acc1.showTransactionHistory();
  acc4.showTransactionHistory();
}