//
//  SleepCalculatorTests.swift
//  DozeTests
//
//  Created by Gadiel Uicab on 22/09/26.
//

import Testing
import Foundation
@testable import Doze

struct SleepCalculatorTests {

    let calculator = SleepCalculator()
    let latencyMinutes = 15

    // 1. Prueba para calculateWakeUpTimes
    @Test("Cálculo de horas para despertar")
    func testCalculateWakeUpTimes() throws {
        let bedTime = Date()
        let wakeUpTimes = calculator.calculateWakeUpTimes(from: bedTime, latencyMinutes: latencyMinutes)

        #expect(!wakeUpTimes.isEmpty, "La lista de horarios calculados no debería estar vacía.")
        #expect(wakeUpTimes.count == 5, "Debería generar 5 opciones de horario.")
    }

    // 2. Prueba para calculateBedTimes
    @Test("Cálculo de horas para ir a dormir")
    func testCalculateBedTimes() throws {
        let targetWakeTime = Date()
        let bedTimes = calculator.calculateBedTimes(for: targetWakeTime, latencyMinutes: latencyMinutes)

        #expect(!bedTimes.isEmpty, "La lista de horarios de dormir no debería estar vacía.")
        #expect(bedTimes.count == 5, "Debería generar 5 opciones de horario.")
    }

    // 3. Prueba para calculateCompletedCycles
    @Test("Cálculo de ciclos completados entre dos fechas")
    func testCalculateCompletedCycles() throws {
        let bedTime = Date()
        // Simula 465 minutos transcurridos (3 ciclos de 90 min = 270 min + 15 min latencia = 285 min total -> probemos 4.5 hrs + latencia)
        // 3 ciclos * 90 min + 15 min latencia = 285 minutos
        let wakeTime = bedTime.addingTimeInterval(TimeInterval(285 * 60))

        let completedCycles = calculator.calculateCompletedCycles(bedTime: bedTime, wakeTime: wakeTime, latencyMinutes: latencyMinutes)

        #expect(completedCycles == 3.0, "Debería calcular exactamente 3 ciclos completos.")
    }

    // 4. Prueba para estimatedSleep
    @Test("Conversión de ciclos a horas estimadas")
    func testEstimatedSleep() throws {
        let cycles = 4 // 4 ciclos * 90 min = 360 min = 6.0 horas
        let estimatedHours = calculator.estimatedSleep(cycles: cycles)

        #expect(estimatedHours == 6.0, "4 ciclos de 90 minutos deberían equivaler a 6.0 horas.")
    }
}
