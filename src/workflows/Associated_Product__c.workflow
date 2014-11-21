<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Contract_Vehicle_Unique_c</fullName>
        <field>Contract_Vehicle_Unique__c</field>
        <formula>CASESAFEID(Contract__c) + CASESAFEID(Product__c)</formula>
        <name>Populate Contract_Vehicle_Unique__c</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Contract_Vehicle_Unique%5F%5Fc field</fullName>
        <actions>
            <name>Populate_Contract_Vehicle_Unique_c</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Contract_Vehicle_Unique__c field for development purpose. This is useful to update total claimed vehicles from Retailed vehicle</description>
        <formula>OR(NOT(ISBLANK(Contract__c))&amp;&amp;NOT(ISBLANK( Product__c )), ISCHANGED(Contract__c) , ISCHANGED(Product__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
