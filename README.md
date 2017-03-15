# loaner

Loaner is a *non-trivial* toy project for learning Functional Programming. 

The goal of loaner is to provide a realistic domain model with a wider breadth of use cases in which to explore functional programming. It follows a somewhat typical enterprise business domain--handling payments on accounts--including the application of relatively complex business rules, interactions with backend services, a UI component, as well as batched processes.

## Key Concepts
- Memberships as products
- Accounts
- Loans
- Accounts Receivable
- Financial Concepts: Interest, Principal, Late Fee, Service Fee
- Members
- Authorized Users

# Memberships
Travel clubs and institutions providing recreational services often provide customers access to the public through a membership model where a membership is purchased, a monthly or annual service or maintenance fee is paid, and the member has access to the facilities or amenities covered in that membership. 

# Process Flow
- Customer purchases product, i.e membership.
- Loan is originated by financial institution.
-- Customer signs legal documents establishing terms, i.e interest rate. 
-- Makes downpayment.
- Bill is generated monthly and sent to customer.
- Customer makes online payments monthly through duration of loan.
- Late fees are assessed when installments are not paid by the due date.

# Features
- Customer can opt to have payments automatically drafted.
- Customer can opt to make additional payments, i.e. pay-down on principal.

# Membership Rules
- Customer cannot make use of membership benefits when account is delinquent more than 60 days. 
- Customer can add authorized users to membership.

# Annual Servicing Fee
- An annual servicing fee is assessed on the member's account, bill is sent to member.
- Member has the option to pay at once or make payments in monthly installments of 3 or 6 months.

# Membership Benefits (Types of Memberships)
- Golf
- Camping
- Hotel accomodations
