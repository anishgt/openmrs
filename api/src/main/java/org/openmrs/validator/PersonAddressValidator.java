/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.validator;

import java.util.Date;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.PersonAddress;
import org.openmrs.annotation.Handler;
import org.openmrs.util.OpenmrsUtil;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

/**
 * This class validates a PersonAddress object.
 *
 * @since 1.9
 */
@Handler(supports = { PersonAddress.class }, order = 50)
public class PersonAddressValidator implements Validator {
	
	private static Log log = LogFactory.getLog(PersonAddressValidator.class);
	
	/**
	 * @see org.springframework.validation.Validator#supports(java.lang.Class)
	 */
	public boolean supports(Class c) {
		return PersonAddress.class.isAssignableFrom(c);
	}
	
	/**
	 * @see org.springframework.validation.Validator#validate(java.lang.Object,
	 *      org.springframework.validation.Errors)
	 * @should pass if all the dates are valid
	 * @should fail if the startDate is in the future
	 * @should fail if the endDate is before the startDate
	 * @should pass if startDate and endDate are both null
	 * @should pass if startDate is null
	 * @should pass if endDate is null
	 */
	public void validate(Object object, Errors errors) {
		//TODO Validate other aspects of the personAddress object
		if (log.isDebugEnabled()) {
			log.debug(this.getClass().getName() + ".validate...");
		}
		
		if (object == null) {
			throw new IllegalArgumentException("The personAddress object should not be null");
		}
		
		PersonAddress personAddress = (PersonAddress) object;
		String patternString = "[-,:\\w\\s]+";
		//Pattern xssPrevention = new Pattern();
		
		if (!Pattern.matches(patternString, personAddress.toString())) {
			log.error(this.getClass().getName() + ": Address:" + personAddress.toString());
			errors.rejectValue("address1", "Invalid characters found in address. "
			        + "Only alphanumeric, space and hyphens allowed");
		}
		
		//resolve a shorter name to display along with the error message
		String addressString = null;
		if (StringUtils.isNotBlank(personAddress.getAddress1())) {
			addressString = personAddress.getAddress1();
		} else if (StringUtils.isNotBlank(personAddress.getAddress2())) {
			addressString = personAddress.getAddress2();
		} else if (StringUtils.isNotBlank(personAddress.getCityVillage())) {
			addressString = personAddress.getCityVillage();
		} else {
			addressString = personAddress.toString();
		}
		
		if (OpenmrsUtil.compareWithNullAsEarliest(personAddress.getStartDate(), new Date()) > 0) {
			errors.rejectValue("startDate", "PersonAddress.error.startDateInFuture", new Object[] { "'" + addressString
			        + "'" }, "The Start Date for address '" + addressString + "' shouldn't be in the future");
		}
		
		if (personAddress.getStartDate() != null
		        && OpenmrsUtil.compareWithNullAsLatest(personAddress.getStartDate(), personAddress.getEndDate()) > 0) {
			errors.rejectValue("endDate", "PersonAddress.error.endDateBeforeStartDate", new Object[] { "'" + addressString
			        + "'" }, "The End Date for address '" + addressString + "' shouldn't be earlier than the Start Date");
		}
		
	}
}
