#!/usr/bin/env python3
import argparse
import sys

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--os-tweaks", help="Walk through OS tweaks setup", action="store_true")
    args = parser.parse_args()

    if len(sys.argv) < 2:
        print("No argument has been provided - executing everything")
        quit()

    if args.os_tweaks:
        print("Executing os tweaks")
