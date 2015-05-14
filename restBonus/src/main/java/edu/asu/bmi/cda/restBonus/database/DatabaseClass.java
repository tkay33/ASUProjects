package edu.asu.bmi.cda.restBonus.database;

import java.util.HashMap;
import java.util.Map;

import edu.asu.bmi.cda.restBonus.model.Patient;


public class DatabaseClass {

	private static Map<Long, Patient> patients = new HashMap<>();

	
	public static Map<Long, Patient> getPatients() {
		return patients;
	}
}
