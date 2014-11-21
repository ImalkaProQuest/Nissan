<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EMA_Booking_Confirmation</fullName>
        <description>EMA_Booking_Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Nissan_Booking_Contact_Email</template>
    </alerts>
    <alerts>
        <fullName>EMA_Final_Cancellation</fullName>
        <description>EMA_Final_Cancellation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Final_Cancellation_Email</template>
    </alerts>
    <alerts>
        <fullName>EMA_Send_Survey</fullName>
        <description>EMA_Send_Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Nissan_Booking_Survey_Contact_Email</template>
    </alerts>
    <alerts>
        <fullName>EMA_SurveyReminder</fullName>
        <description>EMA_SurveyReminder</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Nissan_Representative__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Survey_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Booking_Cancellation_Email_to_Client</fullName>
        <description>Send Booking Cancellation Email to Client</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>sfuser@proquestit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Nissan_Booking_Cancellation_Email_To_Client</template>
    </alerts>
    <alerts>
        <fullName>Send_Booking_Cancellation_Email_to_Nissan_Representative</fullName>
        <description>Send Booking Cancellation Email to Nissan Representative</description>
        <protected>false</protected>
        <recipients>
            <field>Nissan_Representative__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>sfuser@proquestit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Nissan_Booking_Cancellation_Email_To_Nissan_Representative</template>
    </alerts>
    <fieldUpdates>
        <fullName>UPD_EVB_Confirmation_Date</fullName>
        <field>Booking_Confirmation_Sent_Date__c</field>
        <formula>TODAY()</formula>
        <name>UPD_EVB_Confirmation_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPD_EVB_Confirmation_Status</fullName>
        <field>Booking_Confirmation_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>UPD_EVB_Confirmation_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPD_EVB_Confirmation_to_be_sent</fullName>
        <field>Booking_Confirmation_to_be_sent__c</field>
        <literalValue>0</literalValue>
        <name>UPD_EVB_Confirmation_to_be_sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPD_EVB_Survey_Send_Date</fullName>
        <field>Survey_Confirmation_Sent_Date__c</field>
        <formula>TODAY()</formula>
        <name>UPD_EVB_Survey_Send_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPD_EVB_Survey_Status</fullName>
        <field>Survey_Confirmation_Status__c</field>
        <literalValue>Sent</literalValue>
        <name>UPD_EVB_Survey_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UPD_EVB_Survey_to_be_sent</fullName>
        <field>Survey_to_be_Sent__c</field>
        <literalValue>0</literalValue>
        <name>UPD_EVB_Survey_to_be_sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Cancellation_flag</fullName>
        <field>Is_Confirmed_Cancellation__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Cancellation flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WF_EVB01_Survey_Reminder</fullName>
        <active>true</active>
        <formula>NOT(ISBLANK(Survey_Confirmation_Sent_Date__c )) &amp;&amp;  Survey_Form_Completed__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EMA_SurveyReminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Evaluation_Booking__c.Survey_Confirmation_Sent_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WF_EVB02_Send_Booking_Confirmation</fullName>
        <active>true</active>
        <description>If the &apos;Booking Confirmation to be sent&apos; checkbox is checked and &apos;Booking confirmation status&apos; is different to &apos;Sent&apos;: 3 days prior to the booking date the booking confirmation email is sent automatically, the booking confirmation status is updated to &apos;Se</description>
        <formula>Booking_Confirmation_to_be_sent__c = true &amp;&amp;  NOT(ISPICKVAL(Booking_Confirmation_Status__c, &apos;Sent&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EMA_Booking_Confirmation</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>UPD_EVB_Confirmation_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>UPD_EVB_Confirmation_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>UPD_EVB_Confirmation_to_be_sent</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Evaluation_Booking__c.Start_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WF_EVB03_Send_Survey</fullName>
        <active>true</active>
        <formula>Survey_to_be_Sent__c = true &amp;&amp;  NOT(ISPICKVAL(Survey_Confirmation_Status__c, &apos;Sent&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EMA_Send_Survey</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>UPD_EVB_Survey_Send_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>UPD_EVB_Survey_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>UPD_EVB_Survey_to_be_sent</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Evaluation_Booking__c.End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WF_EVB04_Send_Booking_Modification</fullName>
        <actions>
            <name>EMA_Booking_Confirmation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UPD_EVB_Confirmation_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UPD_EVB_Confirmation_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UPD_EVB_Confirmation_to_be_sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the &apos;Booking Confirmation to be sent&apos; checkbox is checked and &apos;Booking confirmation status&apos; is different to &apos;Sent&apos;: 3 days prior to the booking date the booking confirmation email is sent automatically, the booking confirmation status is updated to &apos;Se</description>
        <formula>(ISPICKVAL(PRIORVALUE( Booking_Status__c ), 
&quot;Pending Cancellation&quot;) || ISPICKVAL(PRIORVALUE( Booking_Status__c ), 
&quot;Cancelled&quot;)) &amp;&amp; ISPICKVAL(Booking_Status__c, &quot;Confirmed&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WF_EVB05_Send_Final_Cancellation_email</fullName>
        <actions>
            <name>EMA_Final_Cancellation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Evaluation_Booking__c.Booking_Status__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WF_EVB06_Send Cancellation Email</fullName>
        <actions>
            <name>Send_Booking_Cancellation_Email_to_Client</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Booking_Cancellation_Email_to_Nissan_Representative</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Uncheck_Cancellation_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Booking_Status__c)=&apos;Pending Cancellation&apos;,  ISCHANGED(Is_Confirmed_Cancellation__c), Is_Confirmed_Cancellation__c = TRUE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
