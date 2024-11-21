#This is a MIPS function for simulating a withdraw function found in an ISA of an 8-bit processor that is textbased and Electronic Fund Transacting via  mobile devices.
# Author: XSxociety

#include <iostream>
#using namespace std;

#class Account{

 #   public:
  #  int balance;

   # float Balance();
   # void Withdraw(float Withdrawal_fee);
    #void SendText(string Text,string Reciever);

#};
#void Account::SendText(string Text,string Reciever)
#{
 #    cout<<"Sending message to: "<< Reciever<<endl;
  #   cout<<"Sending..........."<<Text<<endl;
   #  cout<<"Message sent."<<endl;
#}
# float Account::Balance()
#{

 #   return balance;
#}
#void Account::Withdraw(float Withdrawal_fee){

 #   float difference = balance - Withdrawal_fee;

  #  if(difference<0)
   # {
    #    cout<<"insufficient funds, try another amount!!!"<<endl;
    #}
    #else{
     #   balance = difference;
      #  cout<<"Transaction Successful! Available balance is: "<<balance<<endl;

#    }
#}


#int main()
#{
 #   Account objA;
  #  objA.balance = 600;
   # objA.Balance();
    #string Text = "Hello My friend ho joang?";
    #string Reciever ="63395089" ;

    #cout<<objA.Balance()<<endl;
    #objA.SendText(Text,Reciever);
    #return 0;
#}





.data
balance:          .float 600.0           # User's current balance
withdrawal_fee:   .float 253.67          # Fee for withdrawal
insufficient_msg: .asciiz "Insufficient funds, try another amount!!!\n"
success_msg:      .asciiz "Transaction Successful! Available balance is:\n"
newline:         .asciiz "\n"

.text
.globl main

# Function to return balance
Balance:
    la   $a0, balance        # Load address of balance into $a0
    l.s  $f12, 0($a0)        # Load balance into $f12 (float register)
    jr   $ra                 # Return to caller

# Function to withdraw amount
Withdraw:
    la   $a0, balance        # Load address of balance
    l.s  $f0, 0($a0)         # Load current balance into $f0
    la   $a1, withdrawal_fee # Load address of withdrawal fee
    l.s  $f1, 0($a1)         # Load withdrawal fee into $f1

    sub.s $f2, $f0, $f1      # Subtract withdrawal fee from balance, store in $f2 (new balance)

    # Check if the new balance is less than zero
    li.s $f3, 0.0            # Load 0.0 into $f3 for comparison
    c.lt.s $f2, $f3          # Compare if $f2 (new balance) is less than 0
    bc1t insufficient_funds   # If the new balance is less than zero, branch to insufficient_funds

    # Update the balance and print success message
    s.s  $f2, 0($a0)         # Store the new balance back to memory
    li   $v0, 4              # Syscall
    la   $a0, success_msg     # Load success message
    syscall

    # Call PrintBalance to display updated balance
    jal  PrintBalance
    jr   $ra                 # Return from Withdraw function

insufficient_funds:
    li   $v0, 4              # Syscall
    la   $a0, insufficient_msg # Load insufficient funds message
    syscall
    jr   $ra                 # Return from insufficient funds check

# Function to print the balance
PrintBalance:
    li   $v0, 4              # Syscall
    la   $a0, success_msg     # Load success message
    syscall

    la   $a0, balance         # Load address of balance
    l.s  $f12, 0($a0)         # Load balance into (float register)
    li   $v0, 2              # Syscall 
    syscall

    li   $v0, 4              # Print a newline
    la   $a0, newline
    syscall
    jr   $ra                 # Return from PrintBalance

# Main program
main:
    jal Balance              # Display initial balance
    jal Withdraw             # Perform withdrawal
    jal Balance              # Display final balance
    li   $v0, 10             # Exit the program
    syscall

