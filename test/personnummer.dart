import 'package:test/test.dart';
import 'package:personnummer/personnummer.dart';

var invalidNumbers = [
  null,
  [],
  {},
  false,
  true,
  1122334455,
  '112233-4455',
  '19112233-4455',
  '9999999999',
  '199999999999',
  '9913131315',
  '9911311232',
  '19990919_3766',
  '990919_3766',
  '199909193776',
  'Just a string',
  '990919+3776',
  '990919-3776',
  '9909193776',
];

void main() {
  Personnummer.dateTimeNow = new DateTime(2019, 7, 13);

  test('should validate personnummer with control digit', () {
    expect(true, Personnummer.valid(6403273813));
    expect(true, Personnummer.valid('510818-9167'));
    expect(true, Personnummer.valid('19900101-0017'));
    expect(true, Personnummer.valid('19130401+2931'));
    expect(true, Personnummer.valid('196408233234'));
    expect(true, Personnummer.valid('000101-0107'));
    expect(true, Personnummer.valid('0001010107'));
    expect(true, Personnummer.valid('200002296127'));
    expect(true, Personnummer.valid('200002296127'));
    expect(true, Personnummer.valid('200002283422'));
    expect(true, Personnummer.valid('101010-1010'));
  });

  test('should not validate personnummer without control digit', () {
    expect(false, Personnummer.valid(640327381));
    expect(false, Personnummer.valid('510818-916'));
    expect(false, Personnummer.valid('19900101-001'));
    expect(false, Personnummer.valid('100101+001'));
  });

  test('should not validate wrong personnummer or wrong types', () {
    invalidNumbers.forEach((n) => expect(false, Personnummer.valid(n)));
  });

  test('should validate co-ordination numbers', () {
    expect(true, Personnummer.valid('701063-2391'));
    expect(true, Personnummer.valid('640883-3231'));
    expect(true, Personnummer.valid(7010632391));
    expect(true, Personnummer.valid(6408833231));
  });

  test('should not validate wrong co-ordination numbers', () {
    expect(false, Personnummer.valid('900161-0017'));
    expect(false, Personnummer.valid('640893-3231'));
    expect(false, Personnummer.valid('6102802424'));
  });

  test('should not accept co-ordination numbers', () {
    var opts = new PersonnummerOptions(includeCoordinationNumber: false);
    expect(false, Personnummer.valid('701063-2391', opts));
    expect(false, Personnummer.valid('640883-3231', opts));
    expect(false, Personnummer.valid(7010632391, opts));
    expect(false, Personnummer.valid(6408833231, opts));
  });

  test('should format input values correct', () {
    expect('640327-3813', Personnummer.format(6403273813));
    expect('510818-9167', Personnummer.format('510818-9167'));
    expect('900101-0017', Personnummer.format('19900101-0017'));
    expect('130401+2931', Personnummer.format('19130401+2931'));
    expect('640823-3234', Personnummer.format('196408233234'));
    expect('000101-0107', Personnummer.format('0001010107'));
    expect('000101-0107', Personnummer.format('000101-0107'));
    expect('130401+2931', Personnummer.format('191304012931'));

    var opts = new PersonnummerOptions(longFormat: true);
    expect('196403273813', Personnummer.format(6403273813, opts));
    expect('195108189167', Personnummer.format('510818-9167', opts));
    expect('199001010017', Personnummer.format('19900101-0017', opts));
    expect('191304012931', Personnummer.format('19130401+2931', opts));
    expect('196408233234', Personnummer.format('196408233234', opts));
    expect('200001010107', Personnummer.format('0001010107', opts));
    expect('200001010107', Personnummer.format('000101-0107', opts));
    expect('190001010107', Personnummer.format('000101+0107', opts));
  });

  test('should test format with invalid numbers', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.format(n);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });

  test('should format input values and replace separator with the right one', () {
    expect('130401+2931', Personnummer.format('19130401-2931'));
    expect('900101-0017', Personnummer.format('19900101+0017'));
    expect('121212+1212', Personnummer.format('19121212-1212'));
    expect('121212-1212', Personnummer.format('20121212+1212'));
  });

  test('should test format with invalid numbers', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.format(n);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });

  test('should test age', () {
    expect(55, Personnummer.getAge(6403273813));
    expect(67, Personnummer.getAge('510818-9167'));
    expect(29, Personnummer.getAge('19900101-0017'));
    expect(106, Personnummer.getAge('19130401+2931'));
    expect(19, Personnummer.getAge('200002296127'));
  });

  test('should test age with co-ordination numbers', () {
    expect(48, Personnummer.getAge('701063-2391'));
    expect(54, Personnummer.getAge('640883-3231'));
  });

  test('should test get age with invalid numbers', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.getAge(n);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });

  test('should test sex', () {
    var opts = new PersonnummerOptions(includeCoordinationNumber: false);
    expect(true, Personnummer.isMale(6403273813, opts));
    expect(false, Personnummer.isFemale(6403273813, opts));
    expect(true, Personnummer.isFemale('510818-9167', opts));
    expect(false, Personnummer.isMale('510818-9167', opts));
  });

  test('should test sex with co-ordination numbers', () {
    expect(true, Personnummer.isMale('701063-2391'));
    expect(false, Personnummer.isFemale('701063-2391'));
    expect(true, Personnummer.isFemale('640883-3223'));
    expect(false, Personnummer.isMale('640883-3223'));
  });

  test('should test sex with invalid numbers', () {
    invalidNumbers.forEach((n) {
      try {
        Personnummer.isMale(n);
      } catch (e) {
        expect(true, e != null);
      }

      try {
        Personnummer.isFemale(n);
      } catch (e) {
        expect(true, e != null);
      }
    });
  });
}