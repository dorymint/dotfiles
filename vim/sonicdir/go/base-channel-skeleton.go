package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

// Return do not close channel
func displayDaemon() chan<- string {
	ch := make(chan string)
	go func() {
		for {
			fmt.Println(<-ch)
		}
	}()
	return ch
}

// {Input > modify > Output}
func modifyDaemon(output chan<- string, prefix string) chan<- string {
	input := make(chan string)
	go func() {
		for {
			output <- fmt.Sprintf("%v:%v", prefix, <-input)
		}
	}()
	return input
}

// Proc!!
func proc() {
	outch := displayDaemon()
	ch := modifyDaemon(outch, "hello channel")

	for sc := bufio.NewScanner(os.Stdin); sc.Scan(); {
		if sc.Err() != nil {
			log.Fatalf("proc:%v", sc.Err())
		}
		ch <- sc.Text()
	}
}

func main() {
	proc()
}
