package main

import "fmt"

type employee struct {
	Name string
}

// Pointer Receiver
func (e *employee) addSurname(s string) {
	e.Name = e.Name + " " + s
}

// Receiver
func (e employee) addTitle(t string) {
	e.Name = t + " " + e.Name
}

func main() {
	emp := &employee{"Sagar"}

	fmt.Println("Name before adding Title: ", emp.Name)
	emp.addTitle("Mr.")
	fmt.Println("Name after adding Title: ", emp.Name)

	fmt.Println("Name before adding Surname: ", emp.Name)
	emp.addSurname("Jadhav")
	fmt.Println("Name after adding Surname: ", emp.Name)
}
