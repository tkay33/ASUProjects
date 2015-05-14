package edu.asu.bmi.cda.restBonus.model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class Patient {

	private long pid;
    private String disease;
    private LocalDate birthdate;
    private String name;
    
    public Patient() {
    	
    }
    
    public Patient(long pid, String disease, String name, String birthdate) {
    	this.pid = pid;
    	this.disease = disease;
    	this.name = name;
    	this.birthdate = convertStringtoLocalDate(birthdate);
    }
    
    public LocalDate convertStringtoLocalDate(String input) {
    	String date = input;
    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    	LocalDate dateNew = LocalDate.parse(date, formatter);
    	return dateNew;
    }
    
    public String convertLocalDatetoString(LocalDate input) {
    	LocalDate date = input;
    	DateTimeFormatter format = DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH);
    	String formattedDate = date.format(format);
    	return formattedDate;
    }
    
	public long getPID() {
		return pid;
	}
	public void setPID(long pid) {
		this.pid = pid;
	}
	public String getDisease() {
		return disease;
	}
	public void setDisease(String disease) {
		this.disease = disease;
	}
	public String getBirthDate() {
		return convertLocalDatetoString(birthdate);
	}
	public void setBirthDate(String birthdate) {
		this.birthdate = convertStringtoLocalDate(birthdate);
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
}