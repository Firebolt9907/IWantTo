1. 
a. 
public static int numberOfLeapYears(int year1, int year2) {
	// for (int i = year1 ; i <= year2; i++) {
	// 	if (i  % 4 == 0) {

	// 	}
	// }

	// int count = 0;
	// for (int i = year1; i <= year2; i++) {
	// 	if (i % 4 == 0) {
	// 		count++;
	// 	}
	// }

	// return count;

	int count = 0;
	for (int i = year1; i < year2; i++) {
		if (isLeapYear(i)) {
			count++;
		}
	}
	
	return count;
}

b. 
public static int dayOfWeek(int month, int day, int year) {
	int output = 0;
	output += firstDayOfYear(year);
	output += dayOfYear(month, day, year) - 1;
	output = output % 7;
	return output;
}

2.
public class StepTracker {
	// public StepTracker (int minSteps) {

	// }

	// private int activeDays = 0;
	private ArrayList<Integer> days = new ArrayList<Integer>();
	private int stepGoal;
	public StepTracker (int minSteps) {
		stepGoal = minSteps;
	}

	public void addDailySteps(int steps) {
		days.add((Integer) steps);
	}

	public int activeDays() {
		// for (Integer i : days) {

		// }

		int output = 0;
		for (Integer i : days) {
			if (output >= stepGoal) {
				output++;
			}
		}

		return output;
	}

	public double averageSteps () {
		int top = 0;
		double bottom = (double) days.size();

		for (Integer i : days) {
			top += i;
		}

		return top / bottom;
	}
}

3. 
a. 
public ArrayList<String> getDelimitersList(String[] tokens) {
	ArrayList<String> output = new ArrayList<String>();

	for (String token : tokens) {
		// if (token == openDel || token == )
		if (token.equals(openDel) || token.equals(closeDel)) {
			output.add(token);
		}
	}

	return output;
}

b. 
public boolean isBalanced(ArrayList<String> delimiters) {
	int open = 0;
	int close = 0;

	for (String delim : delimiters) {
		if (delim.equals(openDel)) {
			open++;
		} else if (delim.equals(closeDel)) {
			close++;
		}

		if (close > open) {
			return false;
		}
	}

	return open == close;
}

4. 
a.
public LightBoard(int numRows, int numCols) {
	lights = new boolean[numRows][numCols];

	for (int r = 0; r < numRows; r++){
		for (int c = 0; c < nuwCols; c++) {
			if (Math.random() <= 0.4) {
				lights[r][c] = true;
			} else {
				lights[r][c] = false;
			}
		}
	}
}

b. 
public boolean evaluateLight(int row, int col) {
	// if (lights[row][col] && )
	int top = 0;
	for (boolean t : lights) {
		if (t[col]) {
			top++;
		}
	}

	if (lights[row][col] && top % 2 == 0) {
		return false;
	} else if (!lights[row][col] && top % 3 == 0) {
		return true;
	} else {
		return lights[row][col];
	}
}


2021:
1.
a.
public int scoreGuess(String guess) {
	int output = 0;
	String temp = new String(guess);
	int index = 0;

	while (temp.indexOf(guess) >= 0) {
		output++;
		index = temp.indexOf(guess);
		temp = temp.substring(0, index) + temp.substring(index+guess.length());
	}

	return output * guess.length() * guess.length();
}

b. 
public String findBetterGuess(String str1, String str2) {
	int guess1 = scoreGuess(str1);
	int guess2 = scoreGuess(str2);

	if (guess1 > guess2) {
		return str1;
	} else if (guess1 < guess2) {
		return str2;
	} else if (str1.compareTo(str2) > 0) {
		return str1;
	} else {
		return str2;
	}
}

2. 
public class CombinedTable extends SingleTable {
	private int seats;
	private SingleTable t1;
	private SingleTable t2;

	public CombinedTable(SingleTable table1, SingleTable table2) {
		seats = table1.getNumSeats() + table2.getNumSeats() - 2;
		t1 = table1;
		t2 = table2;
	}

	public canSeat(int people) {
		return people <= seats;
	}

	public getDesirability() {
		double output = 0;
		output += t1.getViewQuality();
		output += t2.getViewQuality();
		output /= 2;
		if (t1.getHeight() != t2.getHeight()) {
			output -= 10;
		}

		return output;
	}
	
}

3.
a.
public void addMembers(String[] names, int gradYear) {
	for (String name : names) {
		memberList.add(new MemberInfo(name, gradYear, true));
	}
}

b. 
public ArrayList<MemberInfo> removeMembers(int year) {
	ArrayList<MemberInfo> output = new ArrayList<MemberInfo>();

	// for (MemberInfo person : memberList) {
	// 	if (person.inGoodStanding() && person.getGradYear() <= year) {
	// 		output.add(person);
	// 	} 
	// 	if (person.getGradYear() <= )
	// }

	for (int i = 0; i < memberList.size(); i++) {
		if (memberList[i].inGoodStanding() && memberList[i].getGradYear() <= year) {
			output.add(memberList[i]);
		}
		if (memberList[i].getGradYear() <= year) {
			memberList.remove(i);
			i--;
		}
	}

	return output;
}

4. 
a.
public static boolean isNonZeroRow(int[][] array2D, int r){
	for (int i : array2D[r]) {
		if (i == 0) {
			return false;
		}
	}
	
	return true;
}

b. 
public static int[][] resize(int[][] array2D) {
	// for (int i = 0; i < numNonZeroRows; i++) {
	// 	if ()
	// }
	int[][] output = new int[numNonzeroRows(array2D)][array2D[0].length];
	int rowsFilled = 0;

	for (int i = 0; i < array2D.length; i++) {
		if (isNonZeroRow(array2D, i)) {
			output[rowsFilled] = array2D[i];
			rowsFilled++;
		}
	}

	return output;
}