#!/bin/python

import csv
import argparse
import pathlib
import sys

def preprocess_csvfile(p : pathlib.Path) -> str:

    with open(p) as csvfile:
        csvreader = csv.reader(csvfile, delimiter=",")

        outputstr = ""

        for row in csvreader:
            first = True
            for cell in row:
                if not first:
                    outputstr += ","
                else:
                    first = False
                
                # Check if it is already in parenthesis
                if len(cell) > 2 and not cell[0] == "{" and not cell[-1] == "}":
                    outputstr += "{"+cell.strip()+"}"
                else:
                    outputstr += cell
            outputstr += "\n"
                
    return outputstr

def main() -> None:
    parser = argparse.ArgumentParser(description='Preprocess a csv and replace "<string>" by {<string>}, so it can be used by the LaTex csvsimple package.')

    parser.add_argument('infiles', type=str, nargs="+",
                    help='an integer for the accumulator')

    parser.add_argument('--inplace', dest='inplace', action='store_true', help='Set this flag to perform the preprocessing in-place. Otherwise the results is plotted to stdout.')

    args = parser.parse_args()
    
    print("Got infile:",args)
    
    for infile in args.infiles:
        
        p = pathlib.Path(infile)
        outputstr = preprocess_csvfile(p)

        if args.inplace:
            with open(infile, "w") as file:
                file.write(outputstr)
        else:
            sys.stdout.write(outputstr)

if __name__ == "__main__":
    main()

