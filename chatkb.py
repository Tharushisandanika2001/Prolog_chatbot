# science_gui_v4.py
# --------------------------------------------------------
# Interactive Science Expert System GUI
# Integrates with Prolog knowledge base (chatkb.pl)
# Covers: Biology, Chemistry, Math, and Physics
# --------------------------------------------------------
# Features:
# - Select domain (Biology, Chemistry, Math, Physics)
# - View example queries and run custom Prolog queries
# - Display results in a scrollable output area
# --------------------------------------------------------

import tkinter as tk
from tkinter import scrolledtext, messagebox
from pyswip import Prolog

# Initialize Prolog
prolog = Prolog()
prolog.consult("chatkb.pl")  # Make sure the Prolog file is in the same folder

# Example queries per domain
EXAMPLES = {
    "biology": [
        "classify_organism(oak_tree, X).",
        "photosynthesis_requirements(oak_tree, R).",
        "locomotion(human, L)."
    ],
    "chemistry": [
        "molar_mass('H2O', M).",
        "can_react('HCl','NaOH', R).",
        "pH_of_solution(0.01, P)."
    ],
    "math": [
        "convert_units(mass, grams, kilograms, 500, R).",
        "average([10,20,30], Avg).",
        "area(circle, 7, A)."
    ],
    "physics": [
        "formula(force, 10, 2, F).",
        "law(newtons_second, L).",
        "motion_type(accelerated, T)."
    ]
}

class ScienceExpertGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("🔬 Science Expert System")
        self.root.geometry("800x650")
        self.root.configure(bg="#f0f4f8")

        # Title
        tk.Label(root, text="Science Expert System", font=("Helvetica", 20, "bold"), bg="#f0f4f8").pack(pady=10)

        # Domain Frame
        domain_frame = tk.Frame(root, bg="#f0f4f8", bd=2, relief="groove")
        domain_frame.pack(pady=5, fill="x", padx=10)
        tk.Label(domain_frame, text="Select Domain:", font=("Helvetica", 12, "bold"), bg="#f0f4f8").pack(side="left", padx=10)
        self.domain_var = tk.StringVar(value="biology")
        domains = ["biology", "chemistry", "math", "physics"]
        self.domain_menu = tk.OptionMenu(domain_frame, self.domain_var, *domains, command=self.update_examples)
        self.domain_menu.config(font=("Helvetica", 12))
        self.domain_menu.pack(side="left", padx=5)

        # Example Queries Frame
        tk.Label(root, text="Example Queries:", font=("Helvetica", 12, "bold"), bg="#f0f4f8").pack(pady=5)
        self.examples_frame = tk.Frame(root, bg="#e8eef5", bd=1, relief="sunken")
        self.examples_frame.pack(pady=5, fill="x", padx=10)

        # Query Input Frame
        input_frame = tk.Frame(root, bg="#f0f4f8")
        input_frame.pack(pady=10)
        tk.Label(input_frame, text="Or enter your own query:", font=("Helvetica", 12, "bold"), bg="#f0f4f8").pack(pady=5)
        self.query_entry = tk.Entry(input_frame, width=60, font=("Helvetica", 12))
        self.query_entry.pack(pady=5)

        # Run Button
        run_btn = tk.Button(root, text="Run Query", command=self.run_query, font=("Helvetica", 12, "bold"),
                            bg="#4a90e2", fg="white", activebackground="#357ABD")
        run_btn.pack(pady=5)

        # Output Frame
        tk.Label(root, text="Output:", font=("Helvetica", 12, "bold"), bg="#f0f4f8").pack(pady=5)
        self.output_area = scrolledtext.ScrolledText(root, width=95, height=15, font=("Courier", 12), bg="#ffffff")
        self.output_area.pack(pady=5, padx=10)

        # Clear Button
        clear_btn = tk.Button(root, text="Clear Output", command=self.clear_output, font=("Helvetica", 12),
                              bg="#d9534f", fg="white", activebackground="#c9302c")
        clear_btn.pack(pady=5)

        # Populate initial examples
        self.update_examples("biology")

        # Display system description at startup
        self.display_intro()

    def display_intro(self):
        """Displays the system description (similar to Prolog start/0)."""
        intro_text = (
            "=======================================\n"
            "      WELCOME TO SCIENCE EXPERT BOT\n"
            "=======================================\n"
            "This system combines knowledge from four main areas:\n"
            "   Biology   - Organisms, classification, photosynthesis.\n"
            "   Chemistry - Elements, compounds, reactions, pH, molar mass.\n"
            "   Math      - Unit conversions, averages, calculations.\n"
            "   Physics   - Forces, laws, and motion types.\n\n"
            " Use the dropdown menu to select a domain.\n"
            " Choose an example query or type your own.\n"
            " ▶ Click 'Run Query' to see Prolog results below.\n"
            "=======================================\n\n"
        )
        self.output_area.insert(tk.END, intro_text)

    def update_examples(self, domain):
        """Updates the list of example queries based on selected domain."""
        for widget in self.examples_frame.winfo_children():
            widget.destroy()

        for query in EXAMPLES[domain]:
            btn = tk.Button(
                self.examples_frame, text=query, font=("Helvetica", 10),
                anchor="w", justify="left",
                bg="#f7f9fc", relief="ridge",
                command=lambda q=query: self.query_entry.delete(0, tk.END) or self.query_entry.insert(0, q)
            )
            btn.pack(fill="x", pady=2, padx=2)

    def run_query(self):
        """Runs the Prolog query entered by the user."""
        query = self.query_entry.get().strip()
        if not query:
            messagebox.showwarning("Input Error", "Please enter a Prolog query.")
            return

        self.output_area.insert(tk.END, f">>> {query}\n")
        try:
            results = list(prolog.query(query))
            if results:
                for r in results:
                    self.output_area.insert(tk.END, f"{r}\n")
            else:
                self.output_area.insert(tk.END, "No results found.\n")
        except Exception as e:
            self.output_area.insert(tk.END, f"Error: {e}\n")

    def clear_output(self):
        """Clears the output display area."""
        self.output_area.delete(1.0, tk.END)
        self.display_intro()  # show intro again after clearing


# Run the GUI
if __name__ == "__main__":
    root = tk.Tk()
    app = ScienceExpertGUI(root)
    root.mainloop()
