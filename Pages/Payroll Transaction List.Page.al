page 50115 "Payroll Transaction List"
{
    PageType = List;
    SourceTable = "Payroll Transaction";
    Caption = 'Payroll Transaction List';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Payroll Period ID"; Rec."Payroll Period ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll period ID.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                }
                field("Department ID"; Rec."Department ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department ID.';
                }
                field("Gross Pay"; Rec."Gross Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the gross pay.';
                }
                field("Net Pay"; Rec."Net Pay")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net pay.';
                }
                field("SSS Contribution"; Rec."SSS Contribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the SSS contribution.';
                }
                field("PhilHealth Contribution"; Rec."PhilHealth Contribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the PhilHealth contribution.';
                }
                field("Pag-IBIG Contribution"; Rec."Pag-IBIG Contribution")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Pag-IBIG contribution.';
                }
                field("Tax Amount"; Rec."Tax Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tax amount.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the transaction.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the created date.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created this transaction.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewTransaction)
            {
                ApplicationArea = All;
                Caption = 'New Transaction';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Create a new payroll transaction.';

                trigger OnAction()
                var
                    PayrollTransactionCard: Page "Payroll Transaction Card";
                begin
                    PayrollTransactionCard.RunModal();
                end;
            }
            action(ProcessTransaction)
            {
                ApplicationArea = All;
                Caption = 'Process Transaction';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Process the selected transaction.';

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Draft then begin
                        Rec.Status := Rec.Status::Processed;
                        Rec.Modify();
                        Message('Transaction %1 is now being processed.', Rec."System ID");
                    end else
                        Error('Only draft transactions can be processed.');
                end;
            }
            action(CompleteTransaction)
            {
                ApplicationArea = All;
                Caption = 'Complete Transaction';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Mark the transaction as completed.';

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Processed then begin
                        Rec.Status := Rec.Status::Completed;
                        Rec.Modify();
                        Message('Transaction %1 has been completed.', Rec."System ID");
                    end else
                        Error('Only processed transactions can be completed.');
                end;
            }
        }
    }
}