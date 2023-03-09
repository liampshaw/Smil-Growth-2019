import re



with open("scripts/latex-header.tex", "r") as f:
	for line in f.readlines():
		print(line.strip("\n"))

with open("data/datasets.csv", "r") as f:
	for i, line in enumerate(f.readlines()):
		if i!=0:
			split_line = re.split(",", line)
			print("\\begin{figure}[h]")
			print("\includegraphics[width=8cm]{output/figs-ggplot/"+split_line[0]+".pdf}")
			print("\caption{\\textbf{Dataset "+split_line[0]+"}: "+split_line[12]+"}")
			print("\end{figure}")
			print("	")


print("\end{document}")