package edu.asu.bmi.cda.restBonus.resources;

import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;


import edu.asu.bmi.cda.restBonus.model.Patient;
import edu.asu.bmi.cda.restBonus.service.PatientService;

@Path("/patients")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class PatientResource {

PatientService patientService = new PatientService();
	
	@GET
	public List<Patient> getPatients() {
		return patientService.getAllPatients();
	}
	@POST
	public Patient addPatient(Patient patient) {
		return patientService.addPatient(patient);
	}
	
	@PUT
	@Path("/{patientId}")
	public Patient updatePatient(@PathParam("patientId") long id, Patient patient) {
		patient.setPID(id);
		return patientService.updatePatient(patient);
	}
	
	@DELETE
	@Path("/{patientId}")
	public void deletePatient(@PathParam("patientId") long id) {
		patientService.removePatient(id);
	}
	
	
	@GET
	@Path("/{patientId}")
	public Patient getPatient(@PathParam("patientId") long id) {
		return patientService.getPatient(id);
	}	
}