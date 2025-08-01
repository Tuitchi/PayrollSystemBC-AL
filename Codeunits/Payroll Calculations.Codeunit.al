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
            SSSAmount := SSSContribution.EmployeeShare
        else
            // Default calculation if no table entry found
            SSSAmount := Round(GrossPay * 0.04, 0.01); // Default 4%

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
            PhilHealthAmount := PhilHealthContribution.EmployeeShare
        else
            // Default calculation if no table entry found
            PhilHealthAmount := Round(GrossPay * 0.03, 0.01); // Default 3%

        exit(PhilHealthAmount);
    end;

    procedure CalculatePagIBIG(GrossPay: Decimal): Decimal
    var
        PayrollSetup: Record "PH Payroll Setup";
        PagIBIG_Pct: Decimal;
    begin
        // Get PagIBIG percentage from setup or use default
        if PayrollSetup.Get('DEFAULT') then
            PagIBIG_Pct := PayrollSetup.PagIBIG_Contribution_Pct
        else
            PagIBIG_Pct := 2.0; // Default 2% if no setup exists

        exit(Round(GrossPay * (PagIBIG_Pct / 100), 0.01));
    end;

    procedure CalculateTax(GrossPay: Decimal; SSSAmount: Decimal; PhilHealthAmount: Decimal; PagIBIGAmount: Decimal): Decimal
    var
        PayrollSetup: Record "PH Payroll Setup";
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

        // Set tax brackets from setup or use defaults
        if PayrollSetup.Get('DEFAULT') then begin
            Tax_Bracket1_Max := PayrollSetup.Tax_Bracket1_Max;
            Tax_Rate1 := PayrollSetup.Tax_Rate1;
            Tax_Bracket2_Max := PayrollSetup.Tax_Bracket2_Max;
            Tax_Rate2 := PayrollSetup.Tax_Rate2;
            Tax_Bracket3_Max := PayrollSetup.Tax_Bracket3_Max;
            Tax_Rate3 := PayrollSetup.Tax_Rate3;
            Tax_Bracket4_Max := PayrollSetup.Tax_Bracket4_Max;
            Tax_Rate4 := PayrollSetup.Tax_Rate4;
            Tax_Rate5 := PayrollSetup.Tax_Rate5;
        end else begin
            // Default tax brackets (simplified example)
            Tax_Bracket1_Max := 20833;  // 250K annual / 12
            Tax_Rate1 := 0;             // 0%
            Tax_Bracket2_Max := 33332;  // 400K annual / 12
            Tax_Rate2 := 15;            // 15%
            Tax_Bracket3_Max := 66666;  // 800K annual / 12
            Tax_Rate3 := 20;            // 20%
            Tax_Bracket4_Max := 166666; // 2M annual / 12
            Tax_Rate4 := 25;            // 25%
            Tax_Rate5 := 30;            // 30%
        end;

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
}