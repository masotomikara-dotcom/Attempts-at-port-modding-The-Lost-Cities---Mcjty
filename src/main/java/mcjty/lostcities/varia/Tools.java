package mcjty.lostcities.varia;

import java.util.List;
import java.util.Random;
import java.util.function.Function;

public class Tools {
    public static <T> T getRandomFromList(Random random, List<T> list, Function<T, Float> weightGetter) {
        if (list.isEmpty()) return null;
        float totalWeight = 0;
        for (T item : list) totalWeight += weightGetter.apply(item);
        float r = random.nextFloat() * totalWeight;
        for (T item : list) {
            r -= weightGetter.apply(item);
            if (r <= 0) return item;
        }
        return list.get(0);
    }
}
