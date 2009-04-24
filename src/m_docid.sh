#!/bin/sh
echo | tai64 | sed 's/@/LD/' | sed 's/ *//g' | tr [:lower:] [:upper:]
