--Task1 pig script
--Register the piggybank jar
REGISTER /usr/local/pig/lib/piggybank.jar
--define the CSVExcel sheet
DEFINE CSVExcelStorage org.apache.pig.piggybank.storage.CSVExcelStorage;
--load the data into the pig relation
load_data = LOAD '/flume_import/' USING CSVExcelStorage(',','NO_MULTILINE','UNIX','SKIP_INPUT_HEADER');
--generate id and response
generate_data = FOREACH load_data GENERATE (chararray)$13 AS timelyResponse;
--filter the record for Yes response
filterRecordYes = FILTER generate_data BY timelyResponse =='Yes';
--group all the yes response
groupRecordYes = GROUP filterRecordYes timelyResponse;
--count the yes response
countRecordYes = FOREACH groupRecordYes GENERATE generate_data.timelyResponse,COUNT(filterRecordYes.timelyResponse);
--filter the record for Yes response
filterRecordNo = FILTER generate_data BY timelyResponse =='No';
--group all the yes response
groupRecordNo = GROUP filterRecordNo timelyResponse;
--count the yes response
countRecordNo = FOREACH groupRecordNo GENERATE generate_data.timelyResponse,COUNT(filterRecordNo.timelyResponse); 
--generate Result
Result = UNION countRecordYes,countRecordNo;
--store the Result a the location in a 
Store Result INTO '/user/acadgild/project/Task1output';




