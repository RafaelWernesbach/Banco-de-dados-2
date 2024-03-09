SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema minimundoUVV
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `minimundoUVV` DEFAULT CHARACTER SET utf8 ;
USE `minimundoUVV` ;

-- -----------------------------------------------------
-- Table `minimundoUVV`.`Professores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`Professores` (
  `matricula_professores` INT(4) UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `email` VARCHAR(95) NOT NULL,
  PRIMARY KEY (`matricula_professores`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`Coordenadores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`Coordenadores` (
  `matricula_cordenador` INT(3) UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `Professores_matricula_professores` INT(4) UNSIGNED NOT NULL,
  PRIMARY KEY (`matricula_cordenador`),
  INDEX `fk_Coordenadores_Professores1_idx` (`Professores_matricula_professores` ASC) VISIBLE,
  CONSTRAINT `fk_Coordenadores_Professores1`
    FOREIGN KEY (`Professores_matricula_professores`)
    REFERENCES `minimundoUVV`.`Professores` (`matricula_professores`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`Cursos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`Cursos` (
  `codigo_cursos` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `carga_horaria` INT UNSIGNED NOT NULL COMMENT 'carga horaria padrao de 3600 horas',
  `Coordenadores_matricula_cordenador` INT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`codigo_cursos`, `Coordenadores_matricula_cordenador`),
  INDEX `fk_Cursos_Coordenadores1_idx` (`Coordenadores_matricula_cordenador` ASC) VISIBLE,
  CONSTRAINT `fk_Cursos_Coordenadores1`
    FOREIGN KEY (`Coordenadores_matricula_cordenador`)
    REFERENCES `minimundoUVV`.`Coordenadores` (`matricula_cordenador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`Materias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`Materias` (
  `codigo_materia` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `carga_horaria` INT NOT NULL COMMENT 'minima de 40 horas',
  PRIMARY KEY (`codigo_materia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`Cursos_has_Materias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`Cursos_has_Materias` (
  `Cursos_codigo_cursos` INT UNSIGNED NOT NULL,
  `Materias_codigo_materia` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Cursos_codigo_cursos`, `Materias_codigo_materia`),
  INDEX `fk_Cursos_has_Materias_Materias1_idx` (`Materias_codigo_materia` ASC) VISIBLE,
  INDEX `fk_Cursos_has_Materias_Cursos_idx` (`Cursos_codigo_cursos` ASC) VISIBLE,
  CONSTRAINT `fk_Cursos_has_Materias_Cursos`
    FOREIGN KEY (`Cursos_codigo_cursos`)
    REFERENCES `minimundoUVV`.`Cursos` (`codigo_cursos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cursos_has_Materias_Materias1`
    FOREIGN KEY (`Materias_codigo_materia`)
    REFERENCES `minimundoUVV`.`Materias` (`codigo_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`Disciplinas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`Disciplinas` (
  `codigo_disciplina` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `vagas` INT NOT NULL COMMENT 'maximo de 60',
  `Materias_codigo_materia` INT UNSIGNED NOT NULL,
  `Professores_matricula_professores` INT(4) UNSIGNED NOT NULL,
  PRIMARY KEY (`codigo_disciplina`, `Materias_codigo_materia`, `Professores_matricula_professores`),
  INDEX `fk_Disciplinas_Materias1_idx` (`Materias_codigo_materia` ASC) VISIBLE,
  INDEX `fk_Disciplinas_Professores1_idx` (`Professores_matricula_professores` ASC) VISIBLE,
  CONSTRAINT `fk_Disciplinas_Materias1`
    FOREIGN KEY (`Materias_codigo_materia`)
    REFERENCES `minimundoUVV`.`Materias` (`codigo_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Disciplinas_Professores1`
    FOREIGN KEY (`Professores_matricula_professores`)
    REFERENCES `minimundoUVV`.`Professores` (`matricula_professores`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`alunos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`alunos` (
  `matricula_alunos` INT(9) UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `Cursos_codigo_cursos` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`matricula_alunos`),
  INDEX `fk_alunos_Cursos1_idx` (`Cursos_codigo_cursos` ASC) VISIBLE,
  CONSTRAINT `fk_alunos_Cursos1`
    FOREIGN KEY (`Cursos_codigo_cursos`)
    REFERENCES `minimundoUVV`.`Cursos` (`codigo_cursos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`email`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`email` (
  `email` VARCHAR(45) NOT NULL,
  `alunos_matricula_alunos` INT(9) UNSIGNED NOT NULL,
  PRIMARY KEY (`email`, `alunos_matricula_alunos`),
  INDEX `fk_email_alunos1_idx` (`alunos_matricula_alunos` ASC) VISIBLE,
  CONSTRAINT `fk_email_alunos1`
    FOREIGN KEY (`alunos_matricula_alunos`)
    REFERENCES `minimundoUVV`.`alunos` (`matricula_alunos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `minimundoUVV`.`alunos_has_Disciplinas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `minimundoUVV`.`alunos_has_Disciplinas` (
  `alunos_matricula_alunos` INT(9) UNSIGNED NOT NULL,
  `Disciplinas_codigo_disciplina` INT UNSIGNED NOT NULL,
  `Disciplinas_Materias_codigo_materia` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`alunos_matricula_alunos`, `Disciplinas_codigo_disciplina`, `Disciplinas_Materias_codigo_materia`),
  INDEX `fk_alunos_has_Disciplinas_Disciplinas1_idx` (`Disciplinas_codigo_disciplina` ASC, `Disciplinas_Materias_codigo_materia` ASC) VISIBLE,
  INDEX `fk_alunos_has_Disciplinas_alunos1_idx` (`alunos_matricula_alunos` ASC) VISIBLE,
  CONSTRAINT `fk_alunos_has_Disciplinas_alunos1`
    FOREIGN KEY (`alunos_matricula_alunos`)
    REFERENCES `minimundoUVV`.`alunos` (`matricula_alunos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alunos_has_Disciplinas_Disciplinas1`
    FOREIGN KEY (`Disciplinas_codigo_disciplina` , `Disciplinas_Materias_codigo_materia`)
    REFERENCES `minimundoUVV`.`Disciplinas` (`codigo_disciplina` , `Materias_codigo_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
