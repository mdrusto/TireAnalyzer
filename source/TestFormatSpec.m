classdef TestFormatSpec
    properties(Constant)
        TestFormats = [
            TestFormat(1, 1051, [
                WaitUntilConditionTestSection("First condition", "FZ", -67, 100), ...
                SpringRateTestSection("Static spring rate"), ...
                WaitUntilConditionTestSection("Second condition", "V", 40.2, 1), ...
                SpringRateTestSection("First dynamic spring rate"), ...
                WaitUntilConditionTestSection("Third condition", "FZ", -200, 200), ...
                SpringRateTestSection("Second dynamic spring rate"), ...
                WaitUntilConditionTestSection("Initial SA condition", "SA", -4, 1), ...
                CamberVaryingTestSection("Inc angles", BoundsFinderN(5, 0.5), [
                    LoadsTestSection("Inc angles loads", BoundsFinderN(5, 250), [
                        WaitUntilConditionTestSection("Inc angles first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Inc angles second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Inc angles SA sweeps", 0, 0.5), ...
                        WaitUntilConditionTestSection("Inc angles second SA condition", "SA", -4, 1)
                        ]), ...
                    SpecifiedEndTestSection("Inc angles end")
                    ]), ...
                SpringRateTestSection("Post-test dynamic spring rate"), ...
                WaitUntilConditionTestSection("Spring condition", "FZ", -50, 150), ...
                SpringRateTestSection("Second static spring rate"), ...
                WaitUntilConditionTestSection("Spring condition 2", "FZ", -200, 150), ...
                SpringRateTestSection("Third dynamic spring rate"), ...
                WaitUntilConditionTestSection("Spring condition 3", "FZ", -200, 50), ...
                PressureVaryingTestSection("First pressures", BoundsFinderN(4, 5), [
                    SpringRateTestSection("First pressures dynamic spring rate"), ...
                    WaitUntilConditionTestSection("First pressures initial condition", "FZ", -640, 100), ...
                    LoadsTestSection("First pressures loads", BoundsFinderN(2, 200), [
                        WaitUntilConditionTestSection("First pressures first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("First pressures second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("First pressures SA sweeps", 0, 0.5), ...
                        WaitUntilConditionTestSection("First pressures second SA condition", "SA", -4, 1)
                        ])
                    ]), ...
                TestSection("Final 12psi", BoundsFinderN(1, 5), "P", [
                    SpringRateTestSection("Final 12psi dynamic spring rate"), ...
                    LoadsTestSection("Final 12psi loads", BoundsFinderN(2, 200), [
                        WaitUntilConditionTestSection("Final 12psi first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Final 12psi second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                        SpecifiedEndTestSection("Final 12psi loads end")
                        ]), ...
                    SpecifiedEndTestSection("Final 12psi end")
                    ])
                ]), ...
            TestFormat(2, 1052, [
                WaitUntilConditionTestSection("First condition", "FZ", -67, 100), ...
                SpringRateTestSection("Static spring rate"), ...
                WaitUntilConditionTestSection("Second condition", "V", 40.2, 1), ...
                SpringRateTestSection("First dynamic spring rate"), ...
                WaitUntilConditionTestSection("Third condition", "FZ", -200, 200), ...
                SpringRateTestSection("Second dynamic spring rate"), ...
                WaitUntilConditionTestSection("Initial SA condition", "SA", -4, 1), ...
                CamberVaryingTestSection("Inc angles", BoundsFinderN(5, 0.5), [
                    LoadsTestSection("Inc angles loads", BoundsFinderN(5, 250), [
                        WaitUntilConditionTestSection("Inc angles first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Inc angles second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Inc angles SA sweeps", 0, 0.5), ...
                        WaitUntilConditionTestSection("Inc angles second SA condition", "SA", -4, 1)
                        ]), ...
                    SpecifiedEndTestSection("Inc angles end")
                    ]), ...
                SpringRateTestSection("Post-test dynamic spring rate"), ...
                WaitUntilConditionTestSection("Spring condition", "FZ", -50, 150), ...
                SpringRateTestSection("Second static spring rate"), ...
                WaitUntilConditionTestSection("Spring condition 2", "FZ", -200, 150), ...
                SpringRateTestSection("Third dynamic spring rate"), ...
                WaitUntilConditionTestSection("Spring condition 3", "FZ", -200, 50), ...
                PressureVaryingTestSection("First pressures", BoundsFinderN(4, 5), [
                    SpringRateTestSection("First pressures dynamic spring rate"), ...
                    WaitUntilConditionTestSection("First pressures initial condition", "FZ", -640, 100), ...
                    LoadsTestSection("First pressures loads", BoundsFinderN(2, 200), [
                        WaitUntilConditionTestSection("First pressures first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("First pressures second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("First pressures SA sweeps", 0, 0.5), ...
                        WaitUntilConditionTestSection("First pressures second SA condition", "SA", -4, 1)
                        ])
                    ]), ...
                TestSection("Final 12psi", BoundsFinderN(1, 5), "P", [
                    SpringRateTestSection("Final 12psi dynamic spring rate"), ...
                    LoadsTestSection("Final 12psi loads", BoundsFinderN(2, 200), [
                        WaitUntilConditionTestSection("Final 12psi first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Final 12psi second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                        SpecifiedEndTestSection("Final 12psi loads end")
                        ]), ...
                    SpecifiedEndTestSection("Final 12psi end")
                    ])
                ]), ...
            TestFormat(3, 1175, [
                SpringRateTestSection("Static spring rate"), ...
                WaitUntilConditionTestSection("First condition", "V", 40.2, 1), ...
                SpringRateTestSection("First dynamic spring rate"), ...
                WarmupAndConditioningTestSection("Warmup and conditioning"), ...
                WaitUntilConditionTestSection("Initial SA condition", "SA", -4, 1), ...
                CamberVaryingTestSection("Inc angles", BoundsFinderN(5, 0.5), ...
                    LoadsTestSection("Inc angles loads", BoundsFinderN(5, 200), [
                        WaitUntilConditionTestSection("Inc angles first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Inc angles second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Inc angles SA sweeps", 0, 0.5), ...
                        SpecifiedEndTestSection("Spring rate inc angles end")
                        ])), ...
                SpringRateTestSection("Extra dynamic spring rate"), ...
                WaitUntilConditionTestSection("Spring condition", "FZ", -200, 50), ...
                SpringRateTestSection("Second dynamic spring rate"), ...
                WaitUntilConditionTestSection("Spring condition 3", "FZ", -640, 50), ...
                SpringRateTestSection("Extra dynamic spring rate 2"), ...
                WaitUntilConditionTestSection("Spring condition 4", "FZ", -200, 50), ...
                PressureVaryingTestSection("First pressures", BoundsFinderN(3, 5), [
                    WaitUntilConditionTestSection("First pressures initial condition", "FZ", -200, 100), ...
                    SpringRateTestSection("First pressures dynamic spring rate"), ...
                    LoadsTestSection("First pressures loads", BoundsFinderN(5, 200), [
                        WaitUntilConditionTestSection("First pressures first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("First pressures second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("First pressures SA sweeps", 0, 0.5), ...
                        WaitUntilConditionTestSection("First pressures second SA condition", "SA", -4, 1)
                        ])
                    ]), ...
                WaitUntilConditionTestSection("Gap before 12psi", "P", 82, 5), ...
                TestSection("Final 12psi", BoundsFinderN(1, 5), "P", [
                    WaitUntilConditionTestSection("Final 12psi initial condition", "FZ", -200, 100), ...
                    SpringRateTestSection("Final 12psi dynamic spring rate"), ...
                    LoadsTestSection("Final 12psi loads", BoundsFinderN(5, 200), [
                        WaitUntilConditionTestSection("Final 12psi first SA condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Final 12psi second SA condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                        SpecifiedEndTestSection("Final 12psi loads end")
                        ]), ...
                    SpecifiedEndTestSection("Final 12psi end")
                    ])
                ]), ...
            TestFormat(4, 1320, [
                WaitUntilConditionTestSection("First condition", "FZ", -200, 100), ...
                TestSection("Static spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.1, 0.1), "IA", [
                    SpringRateTestSection("Static spring rate"), ...
                    SpecifiedEndTestSection("Static spring rate end")
                    ]), ...
                WaitUntilConditionTestSection("Second condition", "FZ", -200, 100), ...
                TestSection("First dynamic spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.1, 0.1), "IA", [
                    SpringRateTestSection("First dynamic spring rate"), ...
                    SpecifiedEndTestSection("First dynamic spring rate end")
                    ]), ...
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Second dynamic spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.1, 0.1), "IA", [
                    SpringRateTestSection("Second dynamic spring rate"), ...
                    SpecifiedEndTestSection("Second dynamic spring rate end")
                    ]), ...
                WarmupAndConditioningTestSection("Warmup and conditioning"), ...
                PressureVaryingTestSectionWCamber("Pressures", BoundsFinderN(4, 5), [
                    WaitUntilConditionTestSection("Pressures first condition", "FZ", -1550, 200), ...
                    IntermediateLevelCamberTestSection("Inc angles", BoundsFinderSpec([0, 2, 4, 1, 3], 0.1, 0.1), [
                        LoadsTestSection("Loads", BoundsFinderN(5, 200), [
                            WaitUntilConditionTestSection("Loads first SA condition", "SA", -4, 1), ...
                            WaitUntilConditionTestSection("Loads second SA condition", "SA", 0, 1), ...
                            SASweepTestSectionSpec("First SA sweeps", 0, 0.5), ...
                            SpecifiedEndTestSection("Loads end")
                            ]), ...
                        SpecifiedEndTestSection("Inc angles end")
                        ]), ...
                    WaitUntilConditionTestSection("Pressures second condition", "IA", 0, 0.1), ...
                    SpringRateTestSection("Pressures dynamic spring rate"), ...
                    SpecifiedEndTestSection("Pressures end")
                    ]), ...
                TestSection("Final 12psi inc angles", BoundsFinderN(1, 5), "P", [
                    WaitUntilConditionTestSection("Final 12psi first condition", "FZ", -1550, 200), ...
                    IntermediateLevelCamberTestSection("Final 12psi Inc angles", BoundsFinderSpec([0, 2, 4, 1, 3], 0.1, 0.1), [
                        LoadsTestSection("Final 12psi Loads", BoundsFinderN(5, 200), [
                            WaitUntilConditionTestSection("Final 12psi loads first SA condition", "SA", -4, 1), ...
                            WaitUntilConditionTestSection("Final 12psi loads second SA condition", "SA", 0, 1), ...
                            SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                            SpecifiedEndTestSection("Final 12psi loads end")
                            ]), ...
                        SpecifiedEndTestSection("Inc angles end")
                        ]), ...
                    WaitUntilConditionTestSection("Pressures second condition", "IA", 0, 0.1), ...
                    SpringRateTestSection("Pressures dynamic spring rate"), ...
                    SpecifiedEndTestSection("Pressures end")
                    ])
                ]), ...
            TestFormat(5, 1464, [
                WaitUntilConditionTestSection("First condition", "FZ", -200, 100), ...
                TestSection("Static spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.1, 0.1), "IA", [
                    SpringRateTestSection("Static spring rate"), ...
                    SpecifiedEndTestSection("Static spring rate end")
                    ]), ...
                WaitUntilConditionTestSection("Second condition", "FZ", -200, 100), ...
                TestSection("First dynamic spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.1, 0.1), "IA", [
                    SpringRateTestSection("First dynamic spring rate"), ...
                    SpecifiedEndTestSection("First dynamic spring rate end")
                    ]), ...
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Second dynamic spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.1, 0.1), "IA", [
                    SpringRateTestSection("Second dynamic spring rate"), ...
                    SpecifiedEndTestSection("Second dynamic spring rate end")
                    ]), ...
                WarmupAndConditioningTestSection("Warmup"), ...
                PressureVaryingTestSectionWCamber("Main pressures", BoundsFinderSpec([82.5, 67, 95], 10, 10), [
                    WaitUntilConditionTestSection("Main pressures first condition", "FZ", -1550, 150), ...
                    IntermediateLevelCamberTestSection("Main pressures inc angles", BoundsFinderN(5, 0.5), [
                        LoadsTestSection("Main pressures loads", BoundsFinderN(5, 200), [
                            WaitUntilConditionTestSection("Main pressures loads first condition", "SA", -4, 1), ...
                            WaitUntilConditionTestSection("Main pressures loads second condition", "SA", 0, 1), ...
                            SASweepTestSectionSpec("Main pressures SA sweeps", 0, 0.5), ...
                            SpecifiedEndTestSection("Main pressures loads end"), ...
                            ]), ...
                        SpecifiedEndTestSection("Main pressures inc angles end")
                        ]), ...
                    SpringRateTestSection("Main pressures dynamic spring rate"), ...
                    SpecifiedEndTestSection("Main pressures end")
                    ]), ...
                WaitUntilConditionTestSection("Final 12psi condition", "P", 82.5, 1), ... % Insert 8psi block here instead of condition
                TestSection("Final 12psi", BoundsFinderSpec(82.5, 10, 10), "P", [
                    WaitUntilConditionTestSection("Final 12psi first condition", "FZ", -1550, 150), ...
                    IntermediateLevelCamberTestSection("Final 12psi inc angles", BoundsFinderN(5, 0.5), [
                        LoadsTestSection("Final 12psi loads", BoundsFinderN(5, 200), [
                            WaitUntilConditionTestSection("Final 12psi loads first condition", "SA", -4, 1), ...
                            WaitUntilConditionTestSection("Final 12psi loads second condition", "SA", 0, 1), ...
                            SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                            SpecifiedEndTestSection("Final 12psi loads end"), ...
                            ]), ...
                        SpecifiedEndTestSection("Inc angles end")
                        ]), ...
                    SpringRateTestSection("Final 12psi dynamic spring rate"), ...
                    SpecifiedEndTestSection("Final 12psi end")
                    ])
                ]), ...
            TestFormat(6, 1654, [
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Initial spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                    SpringRateTestSection("Initial spring rate", BoundsFinderSpec([-200, -420, -650, -1100, -1530], 120, 120)), ...
                    SpecifiedEndTestSection("Spring rate inc angles end")
                    ]), ...
                BreakInTestSection("Break-in", 13), ...
                PressureVaryingTestSectionWCamber("First pressures", BoundsFinderSpec([83, 70, 97, 55], 5, 5), [
                    SAConditioningTestSection("SA conditioning", BoundsFinderSpec(-1100, 200, 200)), ...
                    IntermediateLevelCamberTestSection("First inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), [
                        LoadsTestSection("First loads", BoundsFinderSpec([-880, -650, -200, -1100, -420], 120, 120), [
                            WaitUntilConditionTestSection("Loads first condition", "SA", -4, 1), ...
                            WaitUntilConditionTestSection("Loads second condition", "SA", 0, 1), ...
                            SASweepTestSectionSpec("First SA sweeps", 0, 0.5), ...
                            SpecifiedEndTestSection("Loads end")
                            ]), ...
                        SpecifiedEndTestSection("Inc angles end"), ...
                        ]), ...
                    TestSection("First pressures dynamic spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                        SpringRateTestSection("First pressure dynamic spring rate", BoundsFinderSpec([-200, -420, -650, -1100, -1530], 200, 200)), ...
                        SpecifiedEndTestSection("Pressures spring rate end")
                        ]), ...
                    SpecifiedEndTestSection("Pressures end")
                    ]), ...
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Remaining 25mph", BoundsFinderSpec(41, 5, 5), "V", ...
                    TestSection("Final 12psi pressure", BoundsFinderSpec(83, 5, 5), "P", [
                        SAConditioningTestSection("SA conditioning", BoundsFinderSpec(-1100, 200, 200)), ...
                        IntermediateLevelCamberTestSection("Final 12psi inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), [
                            LoadsTestSection("Final 12psi loads", BoundsFinderSpec([-1530, -650, -200, -1100, -420], 100, 100), [
                                WaitUntilConditionTestSection("Final 12psi first loads condition", "SA", -4, 1), ...
                                WaitUntilConditionTestSection("Final 12psi second loads condition", "SA", 0, 1), ...
                                SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                                SpecifiedEndTestSection("Final 12psi loads end")
                                ]), ...
                            SpecifiedEndTestSection("Final 12psi inc angles end")
                            ]), ...
                        TestSection("Final 12psi spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                            SpringRateTestSection("Final 12psi spring rate", BoundsFinderSpec([-200, -420, -650, -1100, -1530], 200, 200)), ...
                            SpecifiedEndTestSection("Final 12psi spring rate inc angles end")
                            ]), ...
                        SpecifiedEndTestSection("Final 12psi pressure end")
                        ])), ...
                TestSection("Other speeds", BoundsFinderSpec([24, 72.4], 2, 2), "V", [
                    LoadsTestSection("Other speeds loads", BoundsFinderSpec([-1530, -650, -200, -1100, -420], 100, 100), [
                        WaitUntilConditionTestSection("Other speeds first loads condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Other speeds second loads condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Other speeds SA sweeps", 0, 0.5), ...
                        SpecifiedEndTestSection("Other speeds loads end")
                        ]), ...
                    SpecifiedEndTestSection("Speeds end")
                    ]), ...
                CleaningTestSection("Cleaning")
                ]), ...
            TestFormat(7, 1706, [
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Initial spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                    SpringRateTestSection("Initial spring rate", BoundsFinderSpec([-200, -420, -650, -1100, -1530], 120, 120)), ...
                    SpecifiedEndTestSection("Spring rate inc angles end")
                    ]), ...
                BreakInTestSection("Break-in", 13), ...
                PressureVaryingTestSectionWCamber("First pressures", BoundsFinderSpec([83, 70, 97, 55], 5, 5), [
                    SAConditioningTestSection("SA conditioning", BoundsFinderSpec(-1100, 200, 200)), ...
                    IntermediateLevelCamberTestSection("First inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), [
                        LoadsTestSection("First loads", BoundsFinderSpec([-1530, -650, -200, -1100, -420], 200, 200), [
                            WaitUntilConditionTestSection("Loads first condition", "SA", -4, 1), ...
                            WaitUntilConditionTestSection("Loads second condition", "SA", 0, 1), ...
                            SASweepTestSectionSpec("First SA sweeps", 0, 0.5), ...
                            SpecifiedEndTestSection("Loads end")
                            ]), ...
                        SpecifiedEndTestSection("Inc angles end"), ...
                        ]), ...
                    TestSection("First pressures dynamic spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                        SpringRateTestSection("First pressure dynamic spring rate", BoundsFinderSpec([-200, -420, -650, -1100, -1530], 200, 200)), ...
                        SpecifiedEndTestSection("Pressures spring rate end")
                        ]), ...
                    SpecifiedEndTestSection("Pressures end")
                    ]), ...
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Remaining 25mph", BoundsFinderSpec(41, 5, 5), "V", ...
                    TestSection("Final 12psi pressure", BoundsFinderSpec(83, 5, 5), "P", [
                        SAConditioningTestSection("SA conditioning", BoundsFinderSpec(-1100, 200, 200)), ...
                        TestSection("Final 12psi inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                            LoadsTestSection("Final 12psi loads", BoundsFinderSpec([-1530, -650, -200, -1100, -420], 100, 100), [
                                WaitUntilConditionTestSection("Final 12psi first loads condition", "SA", -4, 1), ...
                                WaitUntilConditionTestSection("Final 12psi second loads condition", "SA", 0, 1), ...
                                SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                                SpecifiedEndTestSection("Final 12psi loads end")
                                ]), ...
                            SpecifiedEndTestSection("Final 12psi inc angles end")
                            ]), ...
                        TestSection("Final 12psi spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                            SpringRateTestSection("Final 12psi spring rate", BoundsFinderSpec([-200, -420, -650, -1100, -1530], 200, 200)), ...
                            SpecifiedEndTestSection("Final 12psi spring rate inc angles end")
                            ]), ...
                        SpecifiedEndTestSection("Final 12psi pressure end")
                        ])), ...
                TestSection("Other speeds", BoundsFinderSpec([24, 72.4], 2, 2), "V", [
                    LoadsTestSection("Other speeds loads", BoundsFinderSpec([-1530, -650, -200, -1100, -420], 100, 100), [
                        WaitUntilConditionTestSection("Other speeds first loads condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Other speeds second loads condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Other speeds SA sweeps", 4, 0.5), ...
                        SpecifiedEndTestSection("Other speeds loads end")
                        ]), ...
                    SpecifiedEndTestSection("Speeds end")
                    ]), ...
                CleaningTestSection("Cleaning")
                ]), ...
            TestFormat(8, 1965, [
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Initial spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                    SpringRateTestSection("Initial spring rate", BoundsFinderSpec([-200, -420, -650, -870, -1100], 120, 120)), ...
                    SpecifiedEndTestSection("Spring rate inc angles end")
                    ]), ...
                BreakInTestSection("Break-in", 13), ...
                PressureVaryingTestSectionWCamber("First pressures", BoundsFinderSpec([83, 70, 97, 55], 10, 10), [
                    SAConditioningTestSection("SA conditioning", BoundsFinderSpec(-1100, 200, 200)), ...
                    TestSectionGap("Loads gap", 1000), ...
                    WaitUntilConditionTestSection("Inc angles start condition", "FZ", -870, 10), ...
                    IntermediateLevelCamberTestSection("First inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), [
                        WaitUntilConditionTestSection("Loads start condition", "SA", -4, 1), ...
                        LoadsTestSection("First loads", BoundsFinderSpec([-870, -650, -200, -1100, -420], 200, 200), [
                            WaitUntilConditionTestSection("Loads first condition", "SA", -4, 1), ...
                            WaitUntilConditionTestSection("Loads second condition", "SA", 0, 1), ...
                            TestSectionGap("SA sweep gap", 400), ...
                            SASweepTestSectionSpec("First SA sweeps", 0, 0.5), ...
                            SpecifiedEndTestSection("Loads end")
                            ]), ...
                        SpecifiedEndTestSection("Inc angles end"), ...
                        ]), ...
                    TestSection("First pressures dynamic spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                        SpringRateTestSection("First pressure dynamic spring rate", BoundsFinderSpec([-200, -420, -650, -870, -1100], 200, 200)), ...
                        SpecifiedEndTestSection("Pressures spring rate end")
                        ]), ...
                    SpecifiedEndTestSection("Pressures end")
                    ]), ...
                ColdToHotTestSection("Cold to hot"), ...
                TestSection("Remaining 25mph", BoundsFinderSpec(41, 2, 2), "V", ...
                    TestSection("Final 12psi pressure", BoundsFinderSpec(83, 10, 10), "P", [
                        SAConditioningTestSection("SA conditioning", BoundsFinderSpec(-1100, 200, 200)), ...
                        TestSectionGap("Loads gap", 1000), ...
                        TestSection("Final 12psi inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                            LoadsTestSection("Final 12psi loads", BoundsFinderSpec([-870, -650, -200, -1100, -420], 100, 100), [
                                WaitUntilConditionTestSection("Final 12psi first loads condition", "SA", -4, 1), ...
                                WaitUntilConditionTestSection("Final 12psi second loads condition", "SA", 0, 1), ...
                                SASweepTestSectionSpec("Final 12psi SA sweeps", 0, 0.5), ...
                                SpecifiedEndTestSection("Final 12psi loads end")
                                ]), ...
                            SpecifiedEndTestSection("Final 12psi inc angles end")
                            ]), ...
                        TestSection("Final 12psi spring rate inc angles", BoundsFinderSpec([0, 2, 4], 0.5, 0.5), "IA", [
                            SpringRateTestSection("Final 12psi spring rate", BoundsFinderSpec([-200, -420, -650, -870, -1100], 200, 200)), ...
                            SpecifiedEndTestSection("Final 12psi spring rate inc angles end")
                            ]), ...
                        SpecifiedEndTestSection("Final 12psi pressure end")
                        ])), ...
                TestSection("Other speeds", BoundsFinderSpec([24, 72.4], 2, 2), "V", [
                    WaitUntilConditionTestSection("Other speeds condition", "FZ", -870, 20), ...
                    LoadsTestSection("Other speeds loads", BoundsFinderSpec([-870, -650, -200, -1100, -420], 200, 20), [
                        WaitUntilConditionTestSection("Other speeds loads condition", "SA", -4, 1), ...
                        WaitUntilConditionTestSection("Other speeds loads condition", "SA", 0, 1), ...
                        SASweepTestSectionSpec("Other speeds SA sweeps", 0, 0.5), ...
                        SpecifiedEndTestSection("Other speeds loads end")
                        ]), ...
                    SpecifiedEndTestSection("Speeds end")
                    ]), ...
                TestSection("Inc angle sweeps pressures", BoundsFinderSpec([55, 70, 83, 97], 5, 5), "P", [
                    TestSection("Inc angle sweeps loads", BoundsFinderSpec([-430, -1100, -1530], 200, 200), "FZ", [
                        IncAngleSweepTestSection("Inc angle sweeps"), ...
                        SpecifiedEndTestSection("Inc angle sweeps end")
                        ]), ...
                    SpecifiedEndTestSection("Inc angle sweeps loads end")
                    ]), ...
                CleaningTestSection("Cleaning")
                ]), ...
            ]
    end
    
    methods(Static)
        function format = getTestFormats
            format = TestFormatSpec.TestFormats;
        end
    end
end