classdef TestFormat < handle
    
    properties
        RoundNum uint8
        FileIDNum uint16
        Tests TestSection
    end
    
    methods
        function obj = TestFormat(roundNum, fileIDNum, tests)
            obj.RoundNum = roundNum;
            obj.FileIDNum = fileIDNum;
            obj.Tests = tests;
        end
    end
end

