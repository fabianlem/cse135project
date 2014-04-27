//Store.java
//import java.util.*;
package store;

public class User{
	private String name;
	private String role;
	private int age;
	private String state;

	//Default constructor
	public User(){

	}

	//Constructor
	public User(String name, String role, int age, String state){
		setName(name);
		setRole(role);
		setAge(age);
		setState(state);
	}

	//Setters
	public void setName(String name){
		this.name = name;
	}

	public void setRole(String role){
		this.role = role;
	}

	public void setAge(int age){
		this.age = age;
	}

	public void setState(String state){
		this.state = state;
	}

	//Getters

	public String getName(){
		return this.name;
	}

	public String getRole(){
		return this.role;
	}

	public int getAge(){
		return this.age;
	}

	public String getState(){
		return this.state;
	}
}