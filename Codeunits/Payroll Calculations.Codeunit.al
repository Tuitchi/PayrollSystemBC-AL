codeunit 50106 "Payroll Calculations"
{
    procedure CalculateSSS(GrossPay: Decimal; CurrentDate: Date): Decimal
    var
        SSSContribution: Record "SSS Contribution";
        SSSAmount: Decimal;
    begin
        // Default if no matching entry found
        SSSAmount := 0;

        // Try to find a matching bracket in the SSS Contribution table
        SSSContribution.Reset();
        SSSContribution.SetFilter("LowRate", '<=%1', GrossPay);
        SSSContribution.SetFilter("HighRate", '>=%1', GrossPay);
        SSSContribution.SetFilter("EffectiveDate", '<=%1', CurrentDate);
        SSSContribution.SetCurrentKey("EffectiveDate");
        SSSContribution.SetAscending("EffectiveDate", false); // Get the most recent applicable rate

        if SSSContribution.FindFirst() then
            SSSAmount := SSSContribution.EmployeeShare;

        exit(SSSAmount);
    end;

    procedure CalculatePhilHealth(GrossPay: Decimal; CurrentDate: Date): Decimal
    var
        PhilHealthContribution: Record "PhilHealth Contribution";
        PhilHealthAmount: Decimal;
    begin
        // Default if no matching entry found
        PhilHealthAmount := 0;

        // Try to find a matching bracket in the PhilHealth contribution table
        PhilHealthContribution.Reset();
        PhilHealthContribution.SetFilter("LowRate", '<=%1', GrossPay);
        PhilHealthContribution.SetFilter("HighRate", '>=%1', GrossPay);
        PhilHealthContribution.SetFilter("EffectiveDate", '<=%1', CurrentDate);
        PhilHealthContribution.SetCurrentKey("EffectiveDate");
        PhilHealthContribution.SetAscending("EffectiveDate", false); // Get the most recent applicable rate

        if PhilHealthContribution.FindFirst() then
            PhilHealthAmount := PhilHealthContribution.EmployeeShare;

        exit(PhilHealthAmount);
    end;
    // Temporary PagIBIG Calculation
    procedure CalculatePagIBIG(GrossPay: Decimal): Decimal
    var
        PagIBIG_Pct: Decimal;
    begin
        PagIBIG_Pct := 2.0;
        // No default value as requested
        exit(Round(GrossPay * (PagIBIG_Pct / 100), 0.01));
    end;
    //Temporary Tax Calculation
    procedure CalculateTax(GrossPay: Decimal; SSSAmount: Decimal; PhilHealthAmount: Decimal; PagIBIGAmount: Decimal): Decimal
    var
        TaxableIncome: Decimal;
        Tax_Bracket1_Max: Decimal;
        Tax_Rate1: Decimal;
        Tax_Bracket2_Max: Decimal;
        Tax_Rate2: Decimal;
        Tax_Bracket3_Max: Decimal;
        Tax_Rate3: Decimal;
        Tax_Bracket4_Max: Decimal;
        Tax_Rate4: Decimal;
        Tax_Rate5: Decimal;
        TaxAmount: Decimal;
    begin
        // Calculate taxable income (Gross pay minus contributions)
        TaxableIncome := GrossPay - SSSAmount - PagIBIGAmount - PhilHealthAmount;

        // Use default tax brackets since setup has been removed
        Tax_Bracket1_Max := 20833;  // 250K annual / 12
        Tax_Rate1 := 0;             // 0%
        Tax_Bracket2_Max := 33332;  // 400K annual / 12
        Tax_Rate2 := 15;            // 15%
        Tax_Bracket3_Max := 66666;  // 800K annual / 12
        Tax_Rate3 := 20;            // 20%
        Tax_Bracket4_Max := 166666; // 2M annual / 12
        Tax_Rate4 := 25;            // 25%
        Tax_Rate5 := 30;            // 30%

        // Apply tax brackets
        if TaxableIncome <= Tax_Bracket1_Max then
            TaxAmount := TaxableIncome * (Tax_Rate1 / 100)
        else if TaxableIncome <= Tax_Bracket2_Max then
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((TaxableIncome - Tax_Bracket1_Max) * (Tax_Rate2 / 100))
        else if TaxableIncome <= Tax_Bracket3_Max then
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((Tax_Bracket2_Max - Tax_Bracket1_Max) * (Tax_Rate2 / 100)) +
                                ((TaxableIncome - Tax_Bracket2_Max) * (Tax_Rate3 / 100))
        else if TaxableIncome <= Tax_Bracket4_Max then
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((Tax_Bracket2_Max - Tax_Bracket1_Max) * (Tax_Rate2 / 100)) +
                                ((Tax_Bracket3_Max - Tax_Bracket2_Max) * (Tax_Rate3 / 100)) +
                                ((TaxableIncome - Tax_Bracket3_Max) * (Tax_Rate4 / 100))
        else
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((Tax_Bracket2_Max - Tax_Bracket1_Max) * (Tax_Rate2 / 100)) +
                                ((Tax_Bracket3_Max - Tax_Bracket2_Max) * (Tax_Rate3 / 100)) +
                                ((Tax_Bracket4_Max - Tax_Bracket3_Max) * (Tax_Rate4 / 100)) +
                                ((TaxableIncome - Tax_Bracket4_Max) * (Tax_Rate5 / 100));

        exit(TaxAmount);
    end;

    procedure CalculateNetPay(GrossPay: Decimal; SSSAmount: Decimal; PhilHealthAmount: Decimal; PagIBIGAmount: Decimal; TaxAmount: Decimal; OtherDeductions: Decimal): Decimal
    var
        TotalContributions: Decimal;
        TotalDeductions: Decimal;
        NetPay: Decimal;
    begin
        // Calculate total government-mandated contributions
        TotalContributions := SSSAmount + PagIBIGAmount + PhilHealthAmount;

        // Calculate total deductions (contributions + tax + other deductions)
        TotalDeductions := TotalContributions + TaxAmount + OtherDeductions;

        // Net Pay = Gross Pay - All Deductions
        NetPay := GrossPay - TotalDeductions;

        // Ensure NetPay is not negative
        if NetPay < 0 then
            NetPay := 0;

        exit(NetPay);
    end;

    procedure CalculateGrossPay(EmployeeNo: Code[20]; PeriodStart: Date; PeriodEnd: Date) GrossPay: Decimal
    var
        Employee: Record Employee;
        DTR: Record "Daily Time Record";
        EmployeeData: Record "Employee Data";
        PayFrequency: Option Monthly,"Semi-Monthly",Weekly,Daily,Project;
    begin
        Employee.Get(EmployeeNo);
        PayFrequency := Employee.PayFrequency;

        case PayFrequency of
            PayFrequency::Monthly:
                GrossPay := CalculateMonthlyPay(Employee, PeriodStart, PeriodEnd);
            PayFrequency::"Semi-Monthly":
                GrossPay := CalculateSemiMonthlyPay(Employee);
            PayFrequency::Weekly:
                GrossPay := CalculateWeeklyPay(Employee, PeriodStart, PeriodEnd);
            PayFrequency::Daily:
                GrossPay := CalculateDailyPay(Employee, PeriodStart, PeriodEnd);
            PayFrequency::Project:
                GrossPay := CalculateProjectPay(Employee, PeriodStart, PeriodEnd);
        end;

        // Add overtime
        DTR.Reset();
        DTR.SetRange("EmployeeId", EmployeeNo);
        DTR.SetRange("Date", PeriodStart, PeriodEnd);
        DTR.SetRange("OTapprove", true);
        if DTR.FindSet() then
            repeat
                GrossPay += CalculateOvertimePay(Employee, DTR);
            until DTR.Next() = 0;
    end;

    local procedure CalculateMonthlyPay(Employee: Record Employee; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        WorkingDays: Integer;
        AbsentDays: Integer;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, Employee."No.");
        if EmployeeData.FindFirst() then
            BaseSalary := EmployeeData.Rate
        else
            BaseSalary := 0;  // Default if no rate is found

        WorkingDays := CalculateWorkingDays(PeriodStart, PeriodEnd);
        AbsentDays := CalculateAbsentDays(Employee."No.", PeriodStart, PeriodEnd);
        exit(BaseSalary - (BaseSalary / WorkingDays * AbsentDays));
    end;

    local procedure CalculateSemiMonthlyPay(Employee: Record Employee): Decimal
    var
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, Employee."No.");
        if EmployeeData.FindFirst() then
            BaseSalary := EmployeeData.Rate
        else
            BaseSalary := 0;  // Default if no rate is found

        // Semi-monthly is half of the monthly salary
        exit(BaseSalary / 2);
    end;

    local procedure CalculateWeeklyPay(Employee: Record Employee; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        WorkingDaysInWeek: Integer;
        AbsentDays: Integer;
        WeeklyRate: Decimal;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, Employee."No.");
        if EmployeeData.FindFirst() then
            BaseSalary := EmployeeData.Rate
        else
            BaseSalary := 0;  // Default if no rate is found

        // Calculate weekly rate (monthly salary / 4.33 weeks per month)
        WeeklyRate := BaseSalary / 4.33;

        // Check for absences
        WorkingDaysInWeek := CalculateWorkingDays(PeriodStart, PeriodEnd);
        AbsentDays := CalculateAbsentDays(Employee."No.", PeriodStart, PeriodEnd);

        // Deduct absences from weekly pay
        exit(WeeklyRate - (WeeklyRate / WorkingDaysInWeek * AbsentDays));
    end;

    local procedure CalculateDailyPay(Employee: Record Employee; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        DTR: Record "Daily Time Record";
        TotalDailyPay: Decimal;
        DailyRate: Decimal;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, Employee."No.");
        if EmployeeData.FindFirst() then
            BaseSalary := EmployeeData.Rate
        else
            BaseSalary := 0;  // Default if no rate is found

        // Calculate daily rate based on monthly salary (assumes 22 working days per month)
        DailyRate := BaseSalary / 22;

        // Sum up all daily pay within the period
        TotalDailyPay := 0;
        DTR.Reset();
        DTR.SetRange(EmployeeId, Employee."No.");
        DTR.SetRange("Date", PeriodStart, PeriodEnd);
        // Cannot use Status field as it doesn't exist in DTR table
        // Counting all records as present for now

        if DTR.FindSet() then
            repeat
                TotalDailyPay += DailyRate;
            until DTR.Next() = 0;

        exit(TotalDailyPay);
    end;

    local procedure CalculateProjectPay(Employee: Record Employee; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, Employee."No.");
        if EmployeeData.FindFirst() then
            BaseSalary := EmployeeData.Rate
        else
            BaseSalary := 0;  // Default if no rate is found

        // Project pay is typically a fixed rate for the project
        // This would normally involve more complex calculations based on project progress
        exit(BaseSalary);  // Using base salary as a default project rate
    end;

    local procedure CalculateOvertimePay(Employee: Record Employee; DTR: Record "Daily Time Record"): Decimal
    var
        OvertimeHours: Decimal;
        HourlyRate: Decimal;
        OvertimeRate: Decimal;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, Employee."No.");
        if EmployeeData.FindFirst() then
            BaseSalary := EmployeeData.Rate
        else
            BaseSalary := 0;  // Default if no rate is found

        // Get overtime hours from DTR
        OvertimeHours := DTR.OTHour;

        // Calculate hourly rate (monthly salary / 22 working days / 8 hours)
        HourlyRate := BaseSalary / 22 / 8;

        // Standard overtime rate is 1.25 times the regular rate
        OvertimeRate := 1.25;

        // Calculate overtime pay
        exit(OvertimeHours * HourlyRate * OvertimeRate);
    end;

    local procedure CalculateWorkingDays(StartDate: Date; EndDate: Date): Integer
    var
        CurrentDate: Date;
        WorkingDays: Integer;
    begin
        WorkingDays := 0;
        CurrentDate := StartDate;

        while CurrentDate <= EndDate do begin
            // Check if the current day is a working day (Monday to Friday)
            if Date2DWY(CurrentDate, 1) <= 5 then  // DWY option 1 returns day of week (1=Monday, 7=Sunday)
                WorkingDays += 1;

            CurrentDate := CalcDate('<+1D>', CurrentDate);
        end;

        exit(WorkingDays);
    end;

    local procedure CalculateAbsentDays(EmployeeNo: Code[20]; StartDate: Date; EndDate: Date): Integer
    var
        DTR: Record "Daily Time Record";
        AbsentDays: Integer;
    begin
        AbsentDays := 0;

        // We don't have a Status field to mark absences, so counting working days without a DTR entry
        // Get working days in period
        AbsentDays := CalculateWorkingDays(StartDate, EndDate);

        // Subtract days with DTR entries
        DTR.Reset();
        DTR.SetRange(EmployeeId, EmployeeNo);
        DTR.SetRange("Date", StartDate, EndDate);
        AbsentDays -= DTR.Count();

        if AbsentDays < 0 then
            AbsentDays := 0;

        exit(AbsentDays);
    end;
}