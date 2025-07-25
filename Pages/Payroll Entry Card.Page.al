page 50103 "Payroll Entry Card"
{
    ApplicationArea = All;
    Caption = 'Payroll Entry';
    PageType = Card;
    SourceTable = "Payroll Entry";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the entry number of the payroll entry.';
                    Editable = false;
                }
                field(EmployeeId; Rec.EmployeeId)
                {
                    ToolTip = 'Specifies the employee number for this payroll entry.';
                    TableRelation = "Employee Data".EmployeeId;
                    LookupPageId = "Employee Rate List";
                    trigger OnValidate()
                    begin
                        if EmployeeRateRec.Get(Rec.EmployeeId) then begin
                            EmployeeNo := EmployeeRateRec.EmployeeNo;
                            Position := EmployeeRateRec.Position;
                            EffectivityDate := EmployeeRateRec.EffectivityDate;
                            TIN := EmployeeRateRec.TIN;
                            SSS := EmployeeRateRec.SSS;
                            PhilHealth := EmployeeRateRec.PhilHealth;
                            PagIBIG := EmployeeRateRec.PagIBIG;
                            BankAccountNo := EmployeeRateRec.BankAccountNo;
                            BankName := EmployeeRateRec.BankName;
                            HireDate := EmployeeRateRec.HireDate;
                            PayFrequency := EmployeeRateRec.PayFrequency;
                            PayType := EmployeeRateRec.PayType;
                            OvertimeRate := EmployeeRateRec.OvertimeRate;
                            HolidayRate := EmployeeRateRec.HolidayRate;
                            Rec.GrossPay := EmployeeRateRec.Rate;

                            // Use EmployeeNo to fetch from standard Employee table
                            if EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
                                FirstName := EmployeeRec."First Name";
                                LastName := EmployeeRec."Last Name";
                            end;
                        end;
                    end;
                }
                field(EmployeeNo; EmployeeNo)
                {
                    Caption = 'Employee No.';
                    Editable = false;
                }
                field(FirstName; FirstName)
                {
                    Caption = 'First Name';
                    Editable = false;
                }
                field(LastName; LastName)
                {
                    Caption = 'Last Name';
                    Editable = false;
                }
                field(Position; Position)
                {
                    Caption = 'Position';
                    Editable = false;
                }
                field(EffectivityDate; EffectivityDate)
                {
                    Caption = 'Effectivity Date';
                    Editable = false;
                }

                field(BankAccountNo; BankAccountNo)
                {
                    Caption = 'Bank Account No.';
                    Editable = false;
                }
                field(BankName; BankName)
                {
                    Caption = 'Bank Name';
                    Editable = false;
                }
                field(HireDate; HireDate)
                {
                    Caption = 'Hire Date';
                    Editable = false;
                }
                field(PayFrequency; PayFrequency)
                {
                    Caption = 'Pay Frequency';
                    Editable = false;
                }
                field(PayType; PayType)
                {
                    Caption = 'Pay Type';
                    Editable = false;
                }
                field(OvertimeRate; OvertimeRate)
                {
                    Caption = 'Overtime Rate';
                    Editable = false;
                }
                field(HolidayRate; HolidayRate)
                {
                    Caption = 'Holiday Rate';
                    Editable = false;
                }
                field(PeriodStart; Rec.PeriodStart)
                {
                    ToolTip = 'Specifies the start date of the payroll period.';
                }
                field(PeriodEnd; Rec.PeriodEnd)
                {
                    ToolTip = 'Specifies the end date of the payroll period.';
                }
                field(PostDate; Rec.PostDate)
                {
                    ToolTip = 'Specifies the posting date of the payroll entry.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the payroll entry.';
                    Editable = false;
                }
            }

            group(Earnings)
            {
                Caption = 'Earnings';

                field(GrossPay; Rec.GrossPay)
                {
                    Caption = 'Gross Pay';
                    Editable = false;
                }
            }

            group(Deductions)
            {
                Caption = 'Deductions';

                group(IDNumbers)
                {
                    Caption = 'Government IDs';

                    field(TIN; TIN)
                    {
                        Caption = 'TIN';
                        ToolTip = 'Tax Identification Number from Employee Data';
                        Editable = false;
                    }
                    field(SSS; SSS)
                    {
                        Caption = 'SSS Number';
                        ToolTip = 'Social Security System Number from Employee Data';
                        Editable = false;
                    }
                    field(PhilHealth; PhilHealth)
                    {
                        Caption = 'PhilHealth Number';
                        ToolTip = 'PhilHealth Number from Employee Data';
                        Editable = false;
                    }
                    field(PagIBIG; PagIBIG)
                    {
                        Caption = 'Pag-IBIG Number';
                        ToolTip = 'Pag-IBIG Number from Employee Data';
                        Editable = false;
                    }
                }

                group(AmountsPaid)
                {
                    Caption = 'Amounts';

                    field(SSS_Rate; SSS_Rate)
                    {
                        Caption = 'SSS Rate %';
                        ToolTip = 'The percentage rate used for SSS from Payroll Setup';
                        Editable = false;
                    }
                    field(SSSAmount; Rec.SSSAmount)
                    {
                        Caption = 'SSS Contribution';
                        ToolTip = 'SSS contribution amount for this pay period';
                        Editable = false;
                    }

                    field(PagIBIG_Rate; PagIBIG_Rate)
                    {
                        Caption = 'Pag-IBIG Rate %';
                        ToolTip = 'The percentage rate used for Pag-IBIG from Payroll Setup';
                        Editable = false;
                    }
                    field(PagibigAmt; Rec.PagibigAmt)
                    {
                        Caption = 'Pag-IBIG Contribution';
                        ToolTip = 'Pag-IBIG contribution amount for this pay period';
                        Editable = false;
                    }

                    field(PhilHealth_Rate; PhilHealth_Rate)
                    {
                        Caption = 'PhilHealth Rate %';
                        ToolTip = 'The percentage rate used for PhilHealth from Payroll Setup';
                        Editable = false;
                    }
                    field(PhilHealthAmt; Rec.PhilHealthAmt)
                    {
                        Caption = 'PhilHealth Contribution';
                        ToolTip = 'PhilHealth contribution amount for this pay period';
                        Editable = false;
                    }

                    field(TaxAmount; Rec.TaxAmount)
                    {
                        Caption = 'Withholding Tax';
                        ToolTip = 'Withholding tax amount for this pay period';
                        Editable = false;
                    }
                    field(OtherDed; Rec.OtherDed)
                    {
                        Caption = 'Other Deductions';
                        ToolTip = 'Other deductions for this pay period';
                        Enabled = StatusIsDraft;
                    }
                }
            }

            group(Total)
            {
                Caption = 'Total';

                field(NetPay; Rec.NetPay)
                {
                    ToolTip = 'Specifies the net pay amount for this payroll entry.';
                    Style = Strong;
                }

                field(TotalDeductions; Rec.SSSAmount + Rec.PagibigAmt + Rec.PhilHealthAmt + Rec.TaxAmount + Rec.OtherDed)
                {
                    Caption = 'Total Deductions';
                    Editable = false;
                }

                field(EmployeeHistoryNetPay; EmployeeHistoryNetPay)
                {
                    Caption = 'Total Net Pay (Employee History)';
                    ToolTip = 'Shows the total net pay for this employee across all payroll entries.';
                    Editable = false;
                    Style = Strong;
                }

                field(EmployeeHistoryEntries; EmployeeHistoryEntries)
                {
                    Caption = 'Total Payroll Entries (Employee)';
                    ToolTip = 'Shows the total number of payroll entries for this employee.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Calculate")
            {
                ApplicationArea = All;
                Caption = 'Calculate';
                Image = Calculate;
                ToolTip = 'Recalculate the payroll entry based on the current setup.';
                Enabled = StatusIsDraft;

                trigger OnAction()
                begin
                    // Get the latest rates from Payroll Setup
                    FetchCurrentRates();

                    // Recalculate all deductions and net pay
                    Rec.Validate(GrossPay, Rec.GrossPay);
                    Rec.Modify(true);
                    CurrPage.Update(false);

                    Message('Deductions recalculated using current contribution rates: SSS: %1%, Pag-IBIG: %2%, PhilHealth: %3%',
                        SSS_Rate, PagIBIG_Rate, PhilHealth_Rate);
                end;
            }

            action("Release")
            {
                ApplicationArea = All;
                Caption = 'Release';
                Image = ReleaseDoc;
                ToolTip = 'Change the status of the payroll entry to Released.';
                Enabled = StatusIsDraft;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Draft then begin
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Reopen")
            {
                ApplicationArea = All;
                Caption = 'Reopen';
                Image = ReOpen;
                ToolTip = 'Change the status of the payroll entry back to Draft.';
                Enabled = StatusIsReleased;

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Released then begin
                        Rec.Status := Rec.Status::Draft;
                        Rec.Modify(true);
                        CurrPage.Update(false);
                    end;
                end;
            }
        }

        area(Navigation)
        {
            action("Payroll Setup")
            {
                ApplicationArea = All;
                Caption = 'PH Payroll Setup';
                Image = Setup;
                RunObject = Page 50101; // "PH Payroll Setup"
                ToolTip = 'View or modify the payroll setup.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StatusIsDraft := Rec.Status = Rec.Status::Draft;
        StatusIsReleased := Rec.Status = Rec.Status::Released;
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(FirstName);
        Clear(LastName);
        Clear(EmployeeNo);
        Clear(Position);
        Clear(EffectivityDate);
        Clear(TIN);
        Clear(SSS);
        Clear(PhilHealth);
        Clear(PagIBIG);
        Clear(BankAccountNo);
        Clear(BankName);
        Clear(HireDate);
        Clear(PayFrequency);
        Clear(PayType);
        Clear(OvertimeRate);
        Clear(HolidayRate);
        Clear(EmployeeHistoryNetPay);
        Clear(EmployeeHistoryEntries);
        Clear(SSS_Rate);
        Clear(PagIBIG_Rate);
        Clear(PhilHealth_Rate);

        if EmployeeRateRec.Get(Rec.EmployeeId) then begin
            EmployeeNo := EmployeeRateRec.EmployeeNo;
            Position := EmployeeRateRec.Position;
            EffectivityDate := EmployeeRateRec.EffectivityDate;
            TIN := EmployeeRateRec.TIN;
            SSS := EmployeeRateRec.SSS;
            PhilHealth := EmployeeRateRec.PhilHealth;
            PagIBIG := EmployeeRateRec.PagIBIG;
            BankAccountNo := EmployeeRateRec.BankAccountNo;
            BankName := EmployeeRateRec.BankName;
            HireDate := EmployeeRateRec.HireDate;
            PayFrequency := EmployeeRateRec.PayFrequency;
            PayType := EmployeeRateRec.PayType;
            OvertimeRate := EmployeeRateRec.OvertimeRate;
            HolidayRate := EmployeeRateRec.HolidayRate;

            // Use EmployeeNo to fetch from standard Employee table
            if EmployeeRec.Get(EmployeeRateRec.EmployeeNo) then begin
                FirstName := EmployeeRec."First Name";
                LastName := EmployeeRec."Last Name";
            end;

            // Fetch Payroll Setup for rates
            FetchCurrentRates();

            // Calculate employee history totals
            CalculateEmployeeHistory();
        end;
    end;

    var
        StatusIsDraft: Boolean;
        StatusIsReleased: Boolean;
        EmployeeRateRec: Record "Employee Data";
        EmployeeRec: Record Employee;
        FirstName: Text[50];
        LastName: Text[50];
        EmployeeNo: Code[20];
        Position: Text[50];
        EffectivityDate: Date;
        TIN: Code[20];
        SSS: Code[20];
        PhilHealth: Code[20];
        PagIBIG: Code[20];
        BankAccountNo: Code[30];
        BankName: Text[100];
        HireDate: Date;
        PayFrequency: Option Monthly,"Semi-Monthly",Weekly,Daily;
        PayType: Option Salary,Hourly;
        OvertimeRate: Decimal;
        HolidayRate: Decimal;
        PayrollSetup: Record "PH Payroll Setup";
        EmployeeHistoryNetPay: Decimal;
        EmployeeHistoryEntries: Integer;
        SSS_Rate: Decimal;
        PagIBIG_Rate: Decimal;
        PhilHealth_Rate: Decimal;

    trigger OnOpenPage()
    begin
        // Initialize the rates on page open
        FetchCurrentRates();
    end;

    local procedure FetchCurrentRates()
    begin
        // Get the current rate percentages from Payroll Setup
        if not PayrollSetup.Get('DEFAULT') then begin
            // If no setup record exists, create one with default values
            Clear(PayrollSetup);
            PayrollSetup.Init();
            PayrollSetup.PrimaryKey := 'DEFAULT';
            PayrollSetup.SSS_Contribution_Pct := 4.5;  // Default SSS rate
            PayrollSetup.PagIBIG_Contribution_Pct := 2; // Default Pag-IBIG rate
            PayrollSetup.PhilHealth_Contribution_Pct := 3; // Default PhilHealth rate
            if PayrollSetup.Insert(true) then; // Use Insert(true) to suppress errors
        end;

        // Set the rate variables for display
        SSS_Rate := PayrollSetup.SSS_Contribution_Pct;
        PagIBIG_Rate := PayrollSetup.PagIBIG_Contribution_Pct;
        PhilHealth_Rate := PayrollSetup.PhilHealth_Contribution_Pct;

        // Force the recalculation to apply these rates if there's already data
        if (Rec.EntryNo <> 0) and (Rec.GrossPay <> 0) then begin
            Rec.Validate(GrossPay, Rec.GrossPay);
            CurrPage.Update(false);
        end;
    end;

    local procedure CalculateEmployeeHistory()
    var
        PayrollEntry: Record "Payroll Entry";
    begin
        Clear(EmployeeHistoryNetPay);
        Clear(EmployeeHistoryEntries);

        PayrollEntry.Reset();
        PayrollEntry.SetRange(EmployeeId, Rec.EmployeeId);

        if PayrollEntry.FindSet() then
            repeat
                EmployeeHistoryNetPay += PayrollEntry.NetPay;
                EmployeeHistoryEntries += 1;
            until PayrollEntry.Next() = 0;
    end;
}