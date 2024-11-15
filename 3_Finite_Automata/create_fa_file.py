def create_fa_file(filename="FA.in"):
    states = ["q0", "q1", "q2"]
    alphabet = ["a", "b"]
    transitions = [
        ("q0", "a", "q1"),
        ("q1", "b", "q2"),
        ("q2", "a", "q2"),
        ("q2", "b", "q1")
    ]
    start_state = "q0"
    final_states = ["q2"]

    with open(filename, 'w') as file:
        file.write("states: " + " ".join(states) + "\n")
        file.write("alphabet: " + " ".join(alphabet) + "\n")
        transition_strs = [f"{src} {symbol} {dest}" for src, symbol, dest in transitions]
        file.write("transitions: " + ", ".join(transition_strs) + "\n")
        file.write("start: " + start_state + "\n")
        file.write("final_states: " + " ".join(final_states) + "\n")

if __name__ == "__main__":
    create_fa_file()