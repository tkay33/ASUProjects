package edu.asu.bmi.cda.restBonus.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import edu.asu.bmi.cda.restBonus.database.DatabaseClass;
import edu.asu.bmi.cda.restBonus.model.Patient;

public class PatientService {

	
private Map<Long, Patient> patients = DatabaseClass.getPatients();
	
	public PatientService() {
		patients.put(1L, new Patient(1, "Hyperthyroidism", "Taruni", "September 29, 1992"));
		patients.put(2L, new Patient(2, "Oral Herpes", "Wesley", "July 18, 1984"));
	}
	
	
	public List<Patient> getAllPatients() {
		return new ArrayList<Patient>(patients.values()); 
	}
	
	public Patient getPatient(long id) {
		return patients.get(id);
	}
	
	public Patient addPatient(Patient patient) {
		patient.setPID(patients.size() + 1);
		patients.put(patient.getPID(), patient);
		return patient;
	}
	
	public Patient updatePatient(Patient patient) {
		if (patient.getPID() <= 0) {
			return null;
		}
		
		patients.put(patient.getPID(), patient);
		return patient;
	}
	
	public Patient removePatient(long id) {
		return patients.remove(id);
	}
	
}