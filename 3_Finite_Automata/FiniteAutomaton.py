class FiniteAutomaton:
    def __init__(self):
        self.states = set()
        self.alphabet = set()
        self.transitions = {}
        self.start_state = None
        self.final_states = set()

    def load_from_file(self, filename):
        with open(filename, 'r') as file:
            lines = file.readlines()

        for line in lines:
            if line.startswith("states:"):
                self.states = set(line.strip().split(":")[1].split())
            elif line.startswith("alphabet:"):
                self.alphabet = set(line.strip().split(":")[1].split())
            elif line.startswith("transitions:"):
                transitions = line.strip().split(":")[1].split(",")
                for transition in transitions:
                    parts = transition.strip().split()
                    src, symbol, dest = parts[0], parts[1], parts[2]
                    if (src, symbol) not in self.transitions:
                        self.transitions[(src, symbol)] = set()
                    self.transitions[(src, symbol)].add(dest)
            elif line.startswith("start:"):
                self.start_state = line.strip().split(":")[1].strip()
            elif line.startswith("final_states:"):
                self.final_states = set(line.strip().split(":")[1].split())

    def display(self):
        print("Set of States:", self.states)
        print("Alphabet:", self.alphabet)
        print("Transitions:")
        for (src, symbol), dest in self.transitions.items():
            print(f"  {src} --{symbol}--> {', '.join(dest)}")
        print("Start State:", self.start_state)
        print("Final States:", self.final_states)

    def is_valid_token(self, token):
        current_states = {self.start_state}

        for symbol in token:
            if symbol not in self.alphabet:
                return False
            next_states = set()
            for state in current_states:
                next_states.update(self.transitions.get((state, symbol), []))
            current_states = next_states

        return bool(current_states.intersection(self.final_states))
