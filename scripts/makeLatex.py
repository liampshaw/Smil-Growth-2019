import csv


with open("scripts/latex-header.tex", "r") as f:
	for line in f.readlines():
		print(line.strip("\n"))


with open("data/datasets.csv", "r") as f:
	for i, split_line in enumerate(csv.reader(f, quotechar='"', delimiter=',',
                     quoting=csv.QUOTE_ALL, skipinitialspace=True)):
		if i!=0:
			if split_line[1]!="yes":
				print("\\begin{figure}[h]")
				print("\includegraphics[width=8cm]{output/figs-ggplot/"+split_line[0]+".pdf}")
				caption = split_line[12]
				print("\caption{\\textbf{Dataset "+split_line[0]+"}: "+caption+"}")
				print("\end{figure}")
				print("	")


print("\end{document}")