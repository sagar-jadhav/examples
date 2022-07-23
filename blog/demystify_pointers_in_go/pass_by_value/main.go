package main

import "fmt"

func main() {
	x := "Sagar"
	fmt.Println("Name before update: ", x)
	addSurname(x)
	fmt.Println("Name after update: ", x)
}

func addSurname(y string) {
	y = y + " Jadhav"
	fmt.Println("Updated name: ", y)
}
