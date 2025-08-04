codeunit 50106 "Payroll Calculations"
{
    procedure CalculateSSS(GrossPay: Decimal; CurrentDate: Date): Decimal
    var
        SSSContribution: Record "SSS Contribution";
        SSSAmount: Decimal;
    begin
        // Validate input parameters
        if GrossPay <= 0 then
            exit(0);

        if CurrentDate = 0D then
            CurrentDate := Today;

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

        exit(Round(SSSAmount, 0.01));
    end;

    procedure CalculatePhilHealth(GrossPay: Decimal; CurrentDate: Date): Decimal
    var
        PhilHealthContribution: Record "PhilHealth Contribution";
        PhilHealthAmount: Decimal;
    begin
        // Validate input parameters
        if GrossPay <= 0 then
            exit(0);

        if CurrentDate = 0D then
            CurrentDate := Today;

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

        exit(Round(PhilHealthAmount, 0.01));
    end;
    // Temporary PagIBIG Calculation
    procedure CalculatePagIBIG(GrossPay: Decimal): Decimal
    var
        PagIBIG_Pct: Decimal;
    begin
        // Validate input parameter
        if GrossPay <= 0 then
            exit(0);

        PagIBIG_Pct := 2.0; // 2% of gross pay
        exit(Round(GrossPay * (PagIBIG_Pct / 100), 0.01));
    end;
    //Temporary Tax Calculation
    procedure CalculateTax(GrossPay: Decimal; SSSAmount: Decimal; PhilHealthAmount: Decimal; PagIBIGAmount: Decimal): Decimal
    var
        TaxableIncome: Decimal;
        AnnualTaxableIncome: Decimal;
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
        MonthlyTaxAmount: Decimal;
    begin
        // Calculate taxable income (Gross pay minus contributions)
        TaxableIncome := GrossPay - SSSAmount - PagIBIGAmount - PhilHealthAmount;

        // Convert to annual for tax bracket comparison
        AnnualTaxableIncome := TaxableIncome * 12;

        // Use annual tax brackets (Philippine tax rates as of 2024)
        Tax_Bracket1_Max := 250000;  // 250K annual
        Tax_Rate1 := 0;             // 0%
        Tax_Bracket2_Max := 400000;  // 400K annual
        Tax_Rate2 := 15;            // 15%
        Tax_Bracket3_Max := 800000;  // 800K annual
        Tax_Rate3 := 20;            // 20%
        Tax_Bracket4_Max := 2000000; // 2M annual
        Tax_Rate4 := 25;            // 25%
        Tax_Rate5 := 30;            // 30%

        // Apply tax brackets to annual income
        if AnnualTaxableIncome <= Tax_Bracket1_Max then
            TaxAmount := AnnualTaxableIncome * (Tax_Rate1 / 100)
        else if AnnualTaxableIncome <= Tax_Bracket2_Max then
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((AnnualTaxableIncome - Tax_Bracket1_Max) * (Tax_Rate2 / 100))
        else if AnnualTaxableIncome <= Tax_Bracket3_Max then
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((Tax_Bracket2_Max - Tax_Bracket1_Max) * (Tax_Rate2 / 100)) +
                                ((AnnualTaxableIncome - Tax_Bracket2_Max) * (Tax_Rate3 / 100))
        else if AnnualTaxableIncome <= Tax_Bracket4_Max then
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((Tax_Bracket2_Max - Tax_Bracket1_Max) * (Tax_Rate2 / 100)) +
                                ((Tax_Bracket3_Max - Tax_Bracket2_Max) * (Tax_Rate3 / 100)) +
                                ((AnnualTaxableIncome - Tax_Bracket3_Max) * (Tax_Rate4 / 100))
        else
            TaxAmount := (Tax_Bracket1_Max * (Tax_Rate1 / 100)) +
                                ((Tax_Bracket2_Max - Tax_Bracket1_Max) * (Tax_Rate2 / 100)) +
                                ((Tax_Bracket3_Max - Tax_Bracket2_Max) * (Tax_Rate3 / 100)) +
                                ((Tax_Bracket4_Max - Tax_Bracket3_Max) * (Tax_Rate4 / 100)) +
                                ((AnnualTaxableIncome - Tax_Bracket4_Max) * (Tax_Rate5 / 100));

        // Convert annual tax back to monthly
        MonthlyTaxAmount := TaxAmount / 12;

        exit(Round(MonthlyTaxAmount, 0.01));
    end;

    procedure CalculateNetPay(GrossPay: Decimal; SSSAmount: Decimal; PhilHealthAmount: Decimal; PagIBIGAmount: Decimal; TaxAmount: Decimal; OtherDeductions: Decimal): Decimal
    var
        TotalContributions: Decimal;
        TotalDeductions: Decimal;
        NetPay: Decimal;
    begin
        // Validate input parameters
        if GrossPay < 0 then
            GrossPay := 0;
        if SSSAmount < 0 then
            SSSAmount := 0;
        if PhilHealthAmount < 0 then
            PhilHealthAmount := 0;
        if PagIBIGAmount < 0 then
            PagIBIGAmount := 0;
        if TaxAmount < 0 then
            TaxAmount := 0;
        if OtherDeductions < 0 then
            OtherDeductions := 0;

        // Calculate total government-mandated contributions
        TotalContributions := SSSAmount + PagIBIGAmount + PhilHealthAmount;

        // Calculate total deductions (contributions + tax + other deductions)
        TotalDeductions := TotalContributions + TaxAmount + OtherDeductions;

        // Net Pay = Gross Pay - All Deductions
        NetPay := GrossPay - TotalDeductions;

        // Ensure NetPay is not negative
        if NetPay < 0 then
            NetPay := 0;

        exit(Round(NetPay, 0.01));
    end;

    procedure CalculateGrossPay(EmployeeNo: Code[20]; PeriodStart: Date; PeriodEnd: Date) GrossPay: Decimal
    var
        DTR: Record "Daily Time Record";
        EmployeeData: Record "Employee Data";
        PayFrequency: Option Monthly,"Semi-Monthly",Weekly,Daily,Project;
    begin
        // Validate input parameters
        if EmployeeNo = '' then
            exit(0);

        if PeriodStart = 0D then
            PeriodStart := CalcDate('<-CM>', Today);
        if PeriodEnd = 0D then
            PeriodEnd := CalcDate('<CM>', Today);

        // First, get the employee data
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, EmployeeNo);
        if not EmployeeData.FindFirst() then begin
            // Log error or handle missing employee data
            exit(0); // Return 0 if employee not found
        end;

        // Validate employee data
        if EmployeeData.Rate <= 0 then
            exit(0); // Return 0 if no rate is set

        PayFrequency := EmployeeData.PayFrequency;

        case PayFrequency of
            PayFrequency::Monthly:
                GrossPay := CalculateMonthlyPay(EmployeeNo, PeriodStart, PeriodEnd);
            PayFrequency::"Semi-Monthly":
                GrossPay := CalculateSemiMonthlyPay(EmployeeNo);
            PayFrequency::Weekly:
                GrossPay := CalculateWeeklyPay(EmployeeNo, PeriodStart, PeriodEnd);
            PayFrequency::Daily:
                GrossPay := CalculateDailyPay(EmployeeNo, PeriodStart, PeriodEnd);
            PayFrequency::Project:
                GrossPay := CalculateProjectPay(EmployeeNo, PeriodStart, PeriodEnd);
        end;

        // Add overtime
        DTR.Reset();
        DTR.SetRange("EmployeeId", EmployeeNo);
        DTR.SetRange("Date", PeriodStart, PeriodEnd);
        DTR.SetRange("OTapprove", true);
        if DTR.FindSet() then
            repeat
                GrossPay += CalculateOvertimePay(EmployeeNo, DTR);
            until DTR.Next() = 0;

        exit(Round(GrossPay, 0.01));
    end;

    local procedure CalculateMonthlyPay(EmployeeNo: Code[20]; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        WorkingDays: Integer;
        AbsentDays: Integer;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, EmployeeNo);
        if not EmployeeData.FindFirst() then
            exit(0);  // Return 0 if employee not found

        BaseSalary := EmployeeData.Rate;
        if BaseSalary <= 0 then
            exit(0);  // Return 0 if no rate is set

        WorkingDays := CalculateWorkingDays(PeriodStart, PeriodEnd);
        if WorkingDays = 0 then
            exit(0);  // Return 0 if no working days in period

        AbsentDays := CalculateAbsentDays(EmployeeNo, PeriodStart, PeriodEnd);

        // Ensure absent days don't exceed working days
        if AbsentDays > WorkingDays then
            AbsentDays := WorkingDays;

        exit(Round(BaseSalary - (BaseSalary / WorkingDays * AbsentDays), 0.01));
    end;

    local procedure CalculateSemiMonthlyPay(EmployeeNo: Code[20]): Decimal
    var
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, EmployeeNo);
        if not EmployeeData.FindFirst() then
            exit(0);  // Return 0 if employee not found

        BaseSalary := EmployeeData.Rate;
        if BaseSalary <= 0 then
            exit(0);  // Return 0 if no rate is set

        // Semi-monthly is half of the monthly salary
        exit(Round(BaseSalary / 2, 0.01));
    end;

    local procedure CalculateWeeklyPay(EmployeeNo: Code[20]; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        WorkingDaysInWeek: Integer;
        AbsentDays: Integer;
        WeeklyRate: Decimal;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, EmployeeNo);
        if not EmployeeData.FindFirst() then
            exit(0);  // Return 0 if employee not found

        BaseSalary := EmployeeData.Rate;
        if BaseSalary <= 0 then
            exit(0);  // Return 0 if no rate is set

        // Calculate weekly rate (monthly salary / 4.33 weeks per month)
        WeeklyRate := BaseSalary / 4.33;

        // Check for absences
        WorkingDaysInWeek := CalculateWorkingDays(PeriodStart, PeriodEnd);
        if WorkingDaysInWeek = 0 then
            exit(0);  // Return 0 if no working days in period

        AbsentDays := CalculateAbsentDays(EmployeeNo, PeriodStart, PeriodEnd);

        // Ensure absent days don't exceed working days
        if AbsentDays > WorkingDaysInWeek then
            AbsentDays := WorkingDaysInWeek;

        // Deduct absences from weekly pay
        exit(Round(WeeklyRate - (WeeklyRate / WorkingDaysInWeek * AbsentDays), 0.01));
    end;

    local procedure CalculateDailyPay(EmployeeNo: Code[20]; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        DTR: Record "Daily Time Record";
        TotalDailyPay: Decimal;
        DailyRate: Decimal;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, EmployeeNo);
        if not EmployeeData.FindFirst() then
            exit(0);  // Return 0 if employee not found

        BaseSalary := EmployeeData.Rate;
        if BaseSalary <= 0 then
            exit(0);  // Return 0 if no rate is set

        // Calculate daily rate based on monthly salary (assumes 22 working days per month)
        DailyRate := BaseSalary / 22;

        // Sum up all daily pay within the period
        TotalDailyPay := 0;
        DTR.Reset();
        DTR.SetRange("EmployeeId", EmployeeNo);
        DTR.SetRange("Date", PeriodStart, PeriodEnd);
        // Cannot use Status field as it doesn't exist in DTR table
        // Counting all records as present for now

        if DTR.FindSet() then
            repeat
                TotalDailyPay += DailyRate;
            until DTR.Next() = 0;

        exit(Round(TotalDailyPay, 0.01));
    end;

    local procedure CalculateProjectPay(EmployeeNo: Code[20]; PeriodStart: Date; PeriodEnd: Date): Decimal
    var
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, EmployeeNo);
        if not EmployeeData.FindFirst() then
            exit(0);  // Return 0 if employee not found

        BaseSalary := EmployeeData.Rate;
        if BaseSalary <= 0 then
            exit(0);  // Return 0 if no rate is set

        // Project pay is typically a fixed rate for the project
        // This would normally involve more complex calculations based on project progress
        exit(Round(BaseSalary, 0.01));  // Using base salary as a default project rate
    end;

    local procedure CalculateOvertimePay(EmployeeNo: Code[20]; DTR: Record "Daily Time Record"): Decimal
    var
        OvertimeHours: Decimal;
        HourlyRate: Decimal;
        OvertimeRate: Decimal;
        EmployeeData: Record "Employee Data";
        BaseSalary: Decimal;
    begin
        // Get employee rate from Employee Data table
        EmployeeData.Reset();
        EmployeeData.SetRange(EmployeeId, EmployeeNo);
        if not EmployeeData.FindFirst() then
            exit(0);  // Return 0 if employee not found

        BaseSalary := EmployeeData.Rate;
        if BaseSalary <= 0 then
            exit(0);  // Return 0 if no rate is set

        // Get overtime hours from DTR
        OvertimeHours := DTR.OTHour;
        if OvertimeHours <= 0 then
            exit(0);  // Return 0 if no overtime hours

        // Calculate hourly rate (monthly salary / 22 working days / 8 hours)
        HourlyRate := BaseSalary / 22 / 8;

        // Standard overtime rate is 1.25 times the regular rate
        OvertimeRate := 1.25;

        // Calculate overtime pay
        exit(Round(OvertimeHours * HourlyRate * OvertimeRate, 0.01));
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
        WorkingDaysInPeriod: Integer;
        DaysWithDTR: Integer;
    begin
        // Calculate total working days in the period
        WorkingDaysInPeriod := CalculateWorkingDays(StartDate, EndDate);

        // Count days with DTR entries (days employee was present)
        DTR.Reset();
        DTR.SetRange(EmployeeId, EmployeeNo);
        DTR.SetRange("Date", StartDate, EndDate);
        DaysWithDTR := DTR.Count();

        // Absent days = Working days - Days with DTR entries
        AbsentDays := WorkingDaysInPeriod - DaysWithDTR;

        // Ensure absent days is not negative
        if AbsentDays < 0 then
            AbsentDays := 0;

        exit(AbsentDays);
    end;
}