package im.zego.zpns_flutter.internal.utils;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.HashMap;
import java.util.Map;

public class ParcelableMap implements Parcelable {
    private Map<String, Object> map;

    public ParcelableMap(Map<String, Object> map) {
        this.map = map;
    }

    protected ParcelableMap(Parcel in) {
        map = new HashMap<>();
        in.readMap(map, Map.class.getClassLoader());
    }

    public static final Creator<ParcelableMap> CREATOR = new Creator<ParcelableMap>() {
        @Override
        public ParcelableMap createFromParcel(Parcel in) {
            return new ParcelableMap(in);
        }

        @Override
        public ParcelableMap[] newArray(int size) {
            return new ParcelableMap[size];
        }
    };

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeMap(map);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public Map<String, Object> getMap() {
        return map;
    }
}
