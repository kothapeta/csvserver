#!/bin/bash
for i in {0..10000}
do
	echo "$i, $RANDOM"
done > inputFile
