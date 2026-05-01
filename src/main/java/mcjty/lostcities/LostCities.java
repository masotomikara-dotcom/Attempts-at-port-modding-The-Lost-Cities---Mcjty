package mcjty.lostcities;

import mcjty.lostcities.setup.Registration;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LostCities {
    public static final String MODID = "lostcities";
    public static final Logger LOGGER = LogManager.getLogger();
    public static LostCitiesImp lostCitiesImp = new LostCitiesImp();

    public LostCities() {
        Registration.init();
    }
}
