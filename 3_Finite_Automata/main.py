from create_fa_file import create_fa_file
from FiniteAutomaton import FiniteAutomaton

create_fa_file("FA.in")
fa = FiniteAutomaton()
fa.load_from_file("FA.in")
fa.display()

token = input("Enter a token to verify: ")
if fa.is_valid_token(token):
    print("The token is valid.")
else:
    print("The token is not valid.")