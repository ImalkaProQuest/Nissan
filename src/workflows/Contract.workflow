<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contract_12_months_expiration_notice</fullName>
        <description>Contract 12 months expiration notice</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Expiration_Notification_12_months</template>
    </alerts>
    <alerts>
        <fullName>Contract_3_months_expiration_notice</fullName>
        <description>Contract 3 months expiration notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Expiration_Notification_3_months</template>
    </alerts>
    <alerts>
        <fullName>Contract_3_months_expiration_notice_to_Account_Owner_Manager</fullName>
        <description>Contract 3 months expiration notice to Account Owner Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Expiration_Notification_3_months</template>
    </alerts>
    <alerts>
        <fullName>Contract_6_months_expiration_notice</fullName>
        <description>Contract 6 months expiration notice</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Contract_Expiration_Notification_6_months</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Contract_Account_Owner_Email</fullName>
        <field>Account_Owner_Manager_Email__c</field>
        <formula>Account.Owner.Manager.Email</formula>
        <name>Update Contract Account Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contract Expiration Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.EndDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_12_months_expiration_notice</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>-365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_6_months_expiration_notice</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>-180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Contract_3_months_expiration_notice</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Contract_3_months_expiration_notice_to_Account_Owner_Manager</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contract.EndDate</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Account status</fullName>
        <active>false</active>
        <formula>ISPICKVAL( Status, &apos;Draft&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Contract Account Owner Manager Email</fullName>
        <actions>
            <name>Update_Contract_Account_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Account_Owner_Manager_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Contract Account Owner Manager Email on Contract Owner Change</fullName>
        <actions>
            <name>Update_Contract_Account_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
